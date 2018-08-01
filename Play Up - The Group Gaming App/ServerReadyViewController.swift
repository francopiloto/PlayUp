//
//  ServerReadyViewController.swift
//  Play Up - The Group Gaming App
//
//  Created by franco on 2018-08-01.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class ServerReadyViewController: UIViewController
{
    private var timer : Timer?;
    private var seconds = GameDatabase.READY_TIME_SECS;
    
    private let db = GameDatabase.getInstance();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer),
                                     userInfo: nil, repeats: true);
        
        db.setStatus("ready");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    @objc private func updateTimer()
    {
        seconds -= 1;
        
        if (seconds > 0) {
            // do some UI nonsense if you want
        }
        else if (seconds <= 0)
        {
            timer?.invalidate();
            Utils.goTo(controller: self, viewId: "serverQuestion");
        }
    }
}
