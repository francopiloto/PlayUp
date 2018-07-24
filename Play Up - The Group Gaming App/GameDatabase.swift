import Foundation
import Firebase

class GameDatabase
{
    private var db = Database.database().reference();
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Create a new game node in the database and return the game ID
     */
    func createNewGame() -> String
    {
        let games = db.child("games");
        
        let gameId = (1...6).map{_ in "\(arc4random_uniform(9) + 1)"};
        let game = games.child("\(gameId.joined())");
        
        game.child("status").setValue("waiting");
        
        return game.key;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Create a new player node in the database inside the <gameId>/players
     * and return the player ID
     */
    func createNewPlayer(gameId:String, nickname:String) -> String
    {
        let player = db.child("games").child(gameId).child("players").childByAutoId();
            
        player.child("name").setValue(nickname);
        player.child("scores").setValue(0);
        player.child("position").setValue(1);
            
        return player.key;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Listen for player addition in the database for a specific gameId
     * and call onPlayerAdded function passing the player name as argument
     */
    func watchForNewPlayers(gameId:String, onPlayerAdded:@escaping (String)->Void)
    {
        let players = db.child("games").child(gameId).child("players");
            
        players.observe(DataEventType.childAdded, with:
        {
            player in
            onPlayerAdded(player.childSnapshot(forPath: "name").value as! String);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Listen for changes in the game status for a specific gameId
     * and call onStatusChanged function passing the new status as argument
     */
    func watchForGameStatusChange(gameId:String, onStatusChanged:@escaping (String)->Void)
    {
        let status = db.child("games").child(gameId).child("status");
        
        status.observe(DataEventType.value, with:
        {
            status in
            onStatusChanged(status.value as! String);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Get information about an specific player
     */
    func getPlayer(gameId:String, playerId:String, onComplete:@escaping (Player)->Void)
    {
        let playerNode = db.child("games").child(gameId).child("players").child(playerId);
        
        playerNode.observeSingleEvent(of: DataEventType.value, with:
        {
            player in
            onComplete(Player(name: player.childSnapshot(forPath: "name").value as! String,
                              scores: player.childSnapshot(forPath: "scores").value as! Int,
                              position: player.childSnapshot(forPath: "position").value as! Int));
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Update information about an specific player
     */
    func updatePlayer(gameId:String, playerId:String, player:Player)
    {
        let playerNode = db.child("games").child(gameId).child("players").child(playerId);
        
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
        let questionNode = db.child("questions").child("q\(questionNumber+1)");
        
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
    
}

class Player
{
    var name:String;
    var scores = 0;
    var position = 1;
    
/* --------------------------------------------------------------------------------------------- */
    
    init(name:String) {
        self.name = name;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    init(name:String, scores:Int, position:Int)
    {
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
