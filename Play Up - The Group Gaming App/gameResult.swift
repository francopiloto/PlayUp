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
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        db.getPlayers(onComplete:
        {
            players in
            let sortedPlayers = players.sorted(by: { $0.scores > $1.scores });
            var position = 1;
            
            for player in sortedPlayers
            {
                player.position = position;
                self.db.updatePlayer(player);
                
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
