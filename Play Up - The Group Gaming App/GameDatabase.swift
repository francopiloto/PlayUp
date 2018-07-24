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
        let games = db.child("games");
        let game = games.child(gameId);
        let players = game.child("players");
        let player = players.childByAutoId();
            
        player.child("name").setValue(nickname);
        player.child("scores").setValue(0);
        player.child("position").setValue(1);
            
        return player.key;
    }
    
/* --------------------------------------------------------------------------------------------- */
    
    /**
     * Listen for player addition in the database for a specific gameId
     * and return the player ID
     */
    func watchForNewPlayers(gameId:String, onPlayerAdded:@escaping (String)->Void)
    {
        let games = db.child("games");
        let game = games.child(gameId);
        let players = game.child("players");
            
        players.observe(DataEventType.childAdded, with:
        {
            player in
            onPlayerAdded(player.childSnapshot(forPath: "name").value as! String);
        });
    }
    
/* --------------------------------------------------------------------------------------------- */
    
}
