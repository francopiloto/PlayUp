//
//  Utils.swift
//  Play Up - The Group Gaming App
//
//  Created by franco on 2018-07-31.
//  Copyright © 2018 Naveen Dushila. All rights reserved.
//

import UIKit

class Utils
{
    
/* --------------------------------------------------------------------------------------------- */
    
    static func goTo(controller:UIViewController, viewId:String)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewId);
        controller.present(viewController, animated: true, completion: nil);
    }

/* --------------------------------------------------------------------------------------------- */
    
}
