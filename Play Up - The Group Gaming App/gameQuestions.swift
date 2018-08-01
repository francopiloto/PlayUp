//
//  gameQuestions.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class gameQuestions: UIViewController
{
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var gameIDLbl: UILabel!
    
    private let db = GameDatabase.getInstance();
    
    private var timer : Timer?;
    private var seconds : TimeInterval = -1;
    private var correctAnswer = 0;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();

        usernameLbl.text = db.playerName;
        gameIDLbl.text = db.gameId;
        
        db.watchForGameStatusChange(onStatusChanged:
        {
            status in
           
            if status.hasPrefix("q")
            {
                let index = status.index(status.startIndex, offsetBy: 1);
                self.setupQuestion(number: UInt(String(status[index]))!);
            }
            else if status == "ready" || status == "done"
            {
                if let timer = self.timer {
                    timer.invalidate();
                }
                
                self.db.stopWatchingForStatusChange();
                Utils.goTo(controller: self, viewId: status == "ready" ? "playerReady" : "userResults");
            }
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    @IBAction func optionSelected(_ sender: UIButton)
    {
        if (sender.tag == correctAnswer && seconds >= 0)
        {
            db.getPlayer(onComplete:
            {
                player in
                player.scores += Int(round(1000 * ( 1 - ((self.seconds / GameDatabase.QUESTION_TIME_SECS ) / 2))));
                
                self.db.updatePlayer(player);
            });
        }
        
        // TODO disable options
    }
    
    @objc private func updateTimer() {
        seconds -= 1;
    }
    
    private func setupQuestion(number:UInt)
    {
        db.getQuestion(questionNumber: number, onComplete:
        {
            question in
            self.correctAnswer = question.answer;
            self.seconds = GameDatabase.QUESTION_TIME_SECS;
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer),
                                              userInfo: nil, repeats: true);
        });
    }
}
