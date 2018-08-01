//
//  getGameID.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class getGameID: UIViewController
{
    private let db = GameDatabase.getInstance();

    @IBOutlet weak var helloUser: UILabel!
    @IBOutlet weak var gameID: UITextField!

        @IBAction func backButton(_ sender: UIButton) {
            
            let welcomeSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = welcomeSB.instantiateViewController(withIdentifier: "getUsername")
            self.present(welcomeVC, animated: true)
            print("Page Move")
        }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        helloUser.text = "Hello " + db.playerName + "! Let's Play!";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

    @IBAction func goButtonPressed(_ sender: UIButton)
    {
        let gameId = self.gameID.text!
        
        if (gameId == "")
        {
            print("gameId is Empty")
            let infoAlert = UIAlertController(title: "Game ID Can't Be Empty!", message: "Enter Game ID Properly.", preferredStyle: .alert)
            
            infoAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil));
            self.present(infoAlert, animated: true, completion: nil)
            return;
        }
        
        db.canJoinGame(gameId: gameId, onComplete:
        {
            canJoin in
            
            if (canJoin)
            {
                self.db.gameId = gameId;
                self.db.createNewPlayer(gameId: gameId, nickname: self.db.playerName);
                
                Utils.goTo(controller: self, viewId: "waiting");
            }
            else
            {
                let infoAlert = UIAlertController(title: "Game ID is not valid!", message: "Enter Game ID Properly.", preferredStyle: .alert)

                infoAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(infoAlert, animated: true, completion: nil);
            }
        });
    }
}
