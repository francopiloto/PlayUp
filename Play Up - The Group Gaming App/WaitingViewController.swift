//
//  WaitingViewController.swift
//  Play Up - The Group Gaming App
//
//  Created by franco on 2018-07-31.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController
{
    private let db = GameDatabase.getInstance();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        db.watchForGameStatusChange(onStatusChanged:
        {
            status in
            
            if (status == "ready")
            {
                self.db.stopWatchingForStatusChange();
                Utils.goTo(controller: self, viewId: "playerReady");
            }
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
