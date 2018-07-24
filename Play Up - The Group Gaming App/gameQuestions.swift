//
//  gameQuestions.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class gameQuestions: UIViewController {

    var username: String = ""
    var gameID: String = ""
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var gameIDLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLbl.text = username
        gameIDLbl.text = gameID
        
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
