import Foundation
import Firebase

class GameDatabase
{
    static let QUESTION_TIME_SECS : TimeInterval = 10;
    static let READY_TIME_SECS : TimeInterval = 3;
    
    var gameId = "";
    var playerId = "";
    var playerName = "";
    
    var numberOfQuestions : UInt = 0;
    var currentQuestion : UInt = 0;
    
    private static var instance : GameDatabase!;
    
    private var db : DatabaseReference;
    private var statusHandle : DatabaseHandle?;
    private var playersHandle : DatabaseHandle?;
    
/* --------------------------------------------------------------------------------------------- */
    
    static func getInstance() -> GameDatabase
    {
        if (instance == nil) {
            instance = GameDatabase();
        }
        
        return instance;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    private init() {
        db = Database.database().reference();
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Create a new game node in the database and store the game ID
     */
    func createNewGame()
    {
        let games = db.child("games");
        
        let gameId = (1...6).map{_ in "\(arc4random_uniform(9) + 1)"};
        let game = games.child("\(gameId.joined())");
        
        game.child("status").setValue("waiting");
        
        self.gameId = game.key;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Check if the game specified by gameId exists and is not done yet
     */
    func canJoinGame(gameId:String, onComplete:@escaping (Bool)->Void)
    {
        db.child("games").observeSingleEvent(of: .value, with:
        {
            games in
            var canJoin = false;
            
            if (games.hasChild(gameId))
            {
                let gameStatus = games.childSnapshot(forPath: gameId).childSnapshot(forPath: "status");
                canJoin = (gameStatus.value as! String) != "done";
            }
            
            onComplete(canJoin);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Create a new player node in the database inside the <gameId>/players
     * and store the player ID
     */
    func createNewPlayer(gameId:String, nickname:String)
    {
        let player = db.child("games").child(gameId).child("players").childByAutoId();
            
        player.child("name").setValue(nickname);
        player.child("scores").setValue(0);
        player.child("position").setValue(1);
            
        self.playerId = player.key;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Listen for player addition in the database for the current gameId
     * and call onPlayerAdded function passing the player's name as argument
     */
    func watchForNewPlayers(onPlayerAdded:@escaping (String)->Void)
    {
        let players = db.child("games").child(gameId).child("players");
        
        stopWatchingForNewPlayers();
        
        playersHandle = players.observe(DataEventType.childAdded, with:
        {
            player in
            onPlayerAdded(player.childSnapshot(forPath: "name").value as! String);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    func stopWatchingForNewPlayers()
    {
        if playersHandle != nil
        {
            let players = db.child("games").child(gameId).child("players");
            players.removeObserver(withHandle: playersHandle!);
            playersHandle = nil;
        }
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Listen for changes in the current game status and call onStatusChanged function
     * passing the new status as argument
     */
    func watchForGameStatusChange(onStatusChanged:@escaping (String)->Void)
    {
        stopWatchingForStatusChange();
        let status = db.child("games").child(gameId).child("status");
        
        statusHandle = status.observe(DataEventType.value, with:
        {
            status in
            onStatusChanged(status.value as! String);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    func stopWatchingForStatusChange()
    {
        if statusHandle != nil
        {
            let status = db.child("games").child(gameId).child("status");
            status.removeObserver(withHandle: statusHandle!);
            statusHandle = nil;
        }
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Get information about current player
     */
    func getPlayer(onComplete:@escaping (Player)->Void)
    {
        let playerNode = db.child("games").child(gameId).child("players").child(playerId);
        
        playerNode.observeSingleEvent(of: DataEventType.value, with:
        {
            player in
            onComplete(Player(id: player.key,
                              name: player.childSnapshot(forPath: "name").value as! String,
                              scores: player.childSnapshot(forPath: "scores").value as! Int,
                              position: player.childSnapshot(forPath: "position").value as! Int));
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Get information about all players
     */
    func getPlayers(onComplete:@escaping ([Player])->Void)
    {
        let playersNode = db.child("games").child(gameId).child("players");
        
        playersNode.observeSingleEvent(of: DataEventType.value, with:
        {	
            players in
            
            var playersArray : [Player] = [];
            let enumerator = players.children;
            
            while let player = enumerator.nextObject() as? DataSnapshot
            {
                playersArray.append(Player(id: player.key,
                                           name: player.childSnapshot(forPath: "name").value as! String,
                                           scores: player.childSnapshot(forPath: "scores").value as! Int,
                                           position: player.childSnapshot(forPath: "position").value as! Int));
            }
            
            onComplete(playersArray);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Update information about an specific player
     */
    func updatePlayer(_ player:Player)
    {
        let playerNode = db.child("games").child(gameId).child("players").child(player.id);
        
        playerNode.child("name").setValue(player.name);
        playerNode.child("scores").setValue(player.scores);
        playerNode.child("position").setValue(player.position);
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Retrieve a question from the database
     * The question number must be a value between 0 and the number of questions
     */
    func getQuestion(questionNumber:UInt, onComplete:@escaping (Question)->Void)
    {
        let questionNode = db.child("questions").child("q\(questionNumber)");
        
        questionNode.observeSingleEvent(of: DataEventType.value, with:
        {
            question in
            let title = question.childSnapshot(forPath: "title").value as! String;
            
            let numOptions = question.childrenCount - 2;
            let options = (0..<numOptions).map
            {
                index in
                question.childSnapshot(forPath: "o\(index)").value as! String;
            };
            
            let answer = question.childSnapshot(forPath: "answer").value as! Int;
            
            onComplete(Question(title: title, options: options, answer: answer));
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Retrieve the number of questions in the database
     */
    func getNumberOfQuestions(onComplete:@escaping (UInt)->Void)
    {
        db.child("questions").observeSingleEvent(of: DataEventType.value, with:
        {
            questions in
            onComplete(questions.childrenCount);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    func setStatus(_ status:String) {
        db.child("games").child(gameId).child("status").setValue(status);
    }
    
/* --------------------------------------------------------------------------------------------- */
    
}

class Player
{
    var id:String;
    var name:String;
    var scores = 0;
    var position = 1;
    
/* --------------------------------------------------------------------------------------------- */
    
    init(id:String, name:String)
    {
        self.id = id;
        self.name = name;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    init(id:String, name:String, scores:Int, position:Int)
    {
        self.id = id;
        self.name = name;
        self.scores = scores;
        self.position = position;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
}

class Question
{
    var title:String;
    var options:[String];
    var answer:Int;
    
/* --------------------------------------------------------------------------------------------- */
    
    init (title:String, options:[String], answer:Int)
    {
        self.title = title;
        self.options = options;
        self.answer = answer;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
}
