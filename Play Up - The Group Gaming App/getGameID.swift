//
//  getGameID.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class getGameID: UIViewController {

    let db = GameDatabase()
    
    var username: String = ""

    @IBOutlet weak var helloUser: UILabel!
    
    @IBOutlet weak var gameID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloUser.text = "Hello " + globalVars.username + "! Let's Play!"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //-- Segue functions
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let gID = gameID.text!
        var chk = true
        
        print("GID Value:")
        print(gID)
        
        if(gID == "")
        {
            print("GID is Empty")
            let infoAlert = UIAlertController(title: "Game ID Can't Be Empty!", message: "Enter Game ID Properly.", preferredStyle: .alert)
            
            infoAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(infoAlert, animated: true, completion: nil)
            
            return chk
            
        }else
        {
            
            db.canJoinGame(gameId: gID, onComplete:
                {
                    canJoin in
                    
                    if (canJoin)
                    {
                        globalVars.gameID = gID
                        
                        let playerId = self.db.createNewPlayer(gameId: gID, nickname:globalVars.username );
                        
                        globalVars.playerID = playerId
                        
                        
                        chk = true
                        print("chk true done:")
                        print(chk)
    
                    }
                    else {
                        let infoAlert = UIAlertController(title: "Game ID is not valid!", message: "Enter Game ID Properly.", preferredStyle: .alert)
                        
                        infoAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        
                        self.present(infoAlert, animated: true, completion: nil)
                        
                        chk = false
                        print("chk false done:")
                        print(chk)
                    }
                    
            })
            print("final print")
            print(chk)
            return chk
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! gameQuestions
        
        dest.gameID = gameID.text!
        dest.username = self.username
        
    }
    

}
