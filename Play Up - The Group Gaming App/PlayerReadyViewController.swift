//
//  PlayerReadyViewController.swift
//  Play Up - The Group Gaming App
//
//  Created by franco on 2018-08-01.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class PlayerReadyViewController: UIViewController
{
    private let db = GameDatabase.getInstance();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        db.watchForGameStatusChange(onStatusChanged:
        {
            status in
            
            if (status != "ready")
            {
                self.db.stopWatchingForStatusChange();
                Utils.goTo(controller: self, viewId: "gameQuestions");
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
