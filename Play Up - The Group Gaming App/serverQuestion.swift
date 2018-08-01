//
//  serverQuestion.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class serverQuestion: UIViewController
{
    @IBOutlet weak var gameID: UILabel!
    @IBOutlet weak var questionDisplay: UITextView!    
    @IBOutlet weak var timeRemains: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    
    private let db = GameDatabase.getInstance();
    private var timer : Timer?;
    private var seconds : TimeInterval = -1;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        gameID.text = db.gameId;
        
        if (db.currentQuestion < db.numberOfQuestions)
        {
            nextQuestion();
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer),
                                         userInfo: nil, repeats: true);
        }
        else {
            Utils.goTo(controller: self, viewId: "gameResult");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    @objc private func updateTimer()
    {
        seconds -= 1;
        
        if (seconds > 0)
        {
            // Update UI
            timeRemains.text = String(format:"00:%02i", Int(seconds));
            
            let timeProgress = Float(Float((10 - Float(seconds))/10))
            timerProgress.progress = timeProgress
        }
        else if (seconds == 0)
        {
            timerProgress.progress = 1
            
            timer?.invalidate();
            Utils.goTo(controller: self, viewId: db.currentQuestion < db.numberOfQuestions ? "serverReady" : "gameResult");
        }
    }
    
    private func nextQuestion()
    {
        db.getQuestion(questionNumber: db.currentQuestion, onComplete:
        {
            question in
            self.updateQuestion(question);
            self.db.setStatus("q\(self.db.currentQuestion)");
            
            self.db.currentQuestion += 1;
        });
    }
    
    private func updateQuestion(_ question:Question)
    {
        questionDisplay.text = question.title
        questionDisplay.insertText("\n A) ")
        questionDisplay.insertText(question.options[0])
        questionDisplay.insertText("\n B) ")
        questionDisplay.insertText(question.options[1])
        questionDisplay.insertText("\n C) ")
        questionDisplay.insertText(question.options[2])
        questionDisplay.insertText("\n D) ")
        questionDisplay.insertText(question.options[3])
        
        seconds = GameDatabase.QUESTION_TIME_SECS;
        timeRemains.text = String(format:"00:%02i", Int(seconds));
    }
}
