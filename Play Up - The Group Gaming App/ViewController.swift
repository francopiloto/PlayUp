//
//  ViewController.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // How to use database functions
        let db = GameDatabase();
        let gameId = db.createNewGame();
        let playerId = db.createNewPlayer(gameId: gameId, nickname: "nickname");
        
        print("####### Game ID: \(gameId)");
        print("####### Player ID: \(playerId)");
        
        db.watchForNewPlayers(gameId: gameId, onPlayerAdded:
        {
            playerName in
            print("####### New player added: \(playerName)");
        });
        
        db.watchForGameStatusChange(gameId: gameId, onStatusChanged:
        {
            status in
            print("####### Game status changed to: \(status)");
        });
        
        db.getPlayer(gameId: gameId, playerId: playerId, onComplete:
        {
            player in
            print("player info:");
            print("Name: \(player.name)");
            print("Scores: \(player.scores)");
            print("Position: \(player.position)");
            
            player.scores += 200;
            db.updatePlayer(gameId: gameId, playerId: playerId, player:player);
        });
        
        db.getNumberOfQuestions(onComplete:
        {
            count in
            
            for i in 0..<count
            {
                db.getQuestion(questionNumber: i, onComplete:
                {
                    question in
                    print("question info:");
                    print("Title: \(question.title)");
                    print("Options: \(question.options)");
                    print("Answer: \(question.answer)");
                });
                
                db.setStatus(gameId: gameId, status: "q\(i)");
            }
        });
        
        db.getPlayers(gameId: gameId, onComplete:
        {
            players in
            
            for player in players
            {
                print("player info:");
                print("Name: \(player.name)");
                print("Scores: \(player.scores)");
                print("Position: \(player.position)");
            }
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

