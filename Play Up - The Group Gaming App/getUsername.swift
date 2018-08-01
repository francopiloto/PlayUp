//
//  getUsername.swift
//  Play Up - The Group Gaming App
//
//  Created by Naveen Dushila on 2018-07-23.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class getUsername: UIViewController
{
    @IBOutlet weak var username: UITextField!
    
    @IBAction func backButton(_ sender: UIButton) {
       
        let welcomeSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = welcomeSB.instantiateViewController(withIdentifier: "HomePage")
        self.present(welcomeVC, animated: true)
        print("Page Move")
    }
    override func viewDidLoad() {
        super.viewDidLoad();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    //-- Segue functions    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        let user = username.text!
        
        if (user == "")
        {
            let infoAlert = UIAlertController(title: "Username Can't Be Empty!", message: "Enter Username Properly.", preferredStyle: .alert)
            
            infoAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(infoAlert, animated: true, completion: nil)
            return false
        }
        else
        {
            GameDatabase.getInstance().playerName = user;
            print("User name acquired: \(user)");
            return true
        }
    }
}
