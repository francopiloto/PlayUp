//
//  getUsername.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class getUsername: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-- Segue functions
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let user = username.text!
        if (user == "")
        {
            let infoAlert = UIAlertController(title: "Username Can't Be Empty!", message: "Enter Username Properly.", preferredStyle: .alert)
            
            infoAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(infoAlert, animated: true, completion: nil)
            return false
        }
        else {
           
            globalVars.username = user
            return true
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! getGameID
        
        // send the data
        dest.username = username.text!
    }

}
