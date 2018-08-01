//
//  serverVC.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class serverVC: UIViewController
{
    @IBOutlet weak var gameID: UILabel!
    @IBOutlet weak var playerList: UITextView!
    @IBAction func backButton(_ sender: UIButton) {
        
        
        
        let welcomeSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = welcomeSB.instantiateViewController(withIdentifier: "HomePage")
        self.present(welcomeVC, animated: true)
        print("Page Move")
    }
    private let db = GameDatabase.getInstance();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        db.createNewGame();
        gameID.text = "Game ID: " + db.gameId;
        playerList.text = "";
        
        print("New game created: \(db.gameId)");
        
        db.watchForNewPlayers(onPlayerAdded:
        {
            playerName in
            self.playerList.insertText("\(playerName)\n");
            
            print("New player added: \(playerName)");
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton)
    {
        db.stopWatchingForNewPlayers();
        
        db.getNumberOfQuestions(onComplete:
        {
            count in
            
            self.db.numberOfQuestions = count;
            self.db.currentQuestion = 0;
            
            print("Starting the game:", self.db.gameId);
            Utils.goTo(controller: self, viewId: "serverReady");
        });
    }
}
