//
//  gameResult.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class gameResult: UIViewController
{
    private let db = GameDatabase.getInstance();
    
    @IBOutlet weak var gameResult: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        db.getPlayers(onComplete:
        {
            players in
            let sortedPlayers = players.sorted(by: { $0.scores > $1.scores });
            var position = 1;
            self.gameResult.text = "Final Result\n"
            self.gameResult.insertText(" \n ---------------------------- \n")
            for player in sortedPlayers
            {
                player.position = position;
                self.db.updatePlayer(player);
                print("Player Ranking")
                self.gameResult.insertText("Player: ")
                self.gameResult.insertText(player.name)
                self.gameResult.insertText("    Position: ")
                self.gameResult.insertText(String(player.position))
                self.gameResult.insertText(" \n ---------------------------- \n")
                
                position += 1;
                
                // TODO: build UI player rank here
                
            }
            
            self.db.setStatus("done");
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
