//
//  serverVC.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class serverVC: UIViewController {

    @IBOutlet weak var gameID: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          let db = GameDatabase()
        let gameId = db.createNewGame()
        
        globalVars.gameIDE = gameId
        
        gameID.text = gameId
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
