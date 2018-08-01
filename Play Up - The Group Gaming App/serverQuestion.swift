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
    
    private let db = GameDatabase.getInstance();
    private var numberOfQuestions : UInt = 0;
    private var currentQuestion : UInt = 0;
    private var timer : Timer?;
    private var seconds : TimeInterval = -1;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        gameID.text = db.gameId;
        
        db.getNumberOfQuestions(onComplete:
        {
            count in
            
            self.numberOfQuestions = count;
            self.currentQuestion = 0;
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer),
                                              userInfo: nil, repeats: true);
            self.nextQuestion();
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    @objc private func updateTimer()
    {
        seconds -= 1;
        
        if (seconds > 0) {
            timeRemains.text = String(format:"00:%02i", Int(seconds));
        }
        else if (seconds == 0) {
            nextQuestion();
        }
    }
    
    private func nextQuestion()
    {
        if (currentQuestion < numberOfQuestions)
        {
            db.getQuestion(questionNumber: currentQuestion, onComplete:
            {
                question in
                self.updateQuestion(question);
                self.db.setStatus("q\(self.currentQuestion)");
                
                self.currentQuestion += 1;
            });
        }
        else
        {
            db.setStatus("done");
            timer?.invalidate();
            
            Utils.goTo(controller: self, viewId: "gameResult");
        }
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
