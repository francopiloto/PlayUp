//
//  userResults.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class userResults: UIViewController
{
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var gameID: UILabel!
    @IBOutlet weak var scores: UILabel!
    @IBOutlet weak var resultPosition: UILabel!
    
    private let db = GameDatabase.getInstance();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        userName.text = db.playerName;
        gameID.text = db.gameId;
        
        db.getPlayer(onComplete:
        {
            player in
            self.scores.text = "\(player.scores)";
            self.resultPosition.text = "\(player.position)";
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
