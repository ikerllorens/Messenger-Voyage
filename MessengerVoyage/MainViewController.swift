//
//  MainViewController.swift
//  UltraDelivery
//
//  Created by Iker on 12/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var userProfile: UserModel = UserModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? HelpViewController {
            destination.tempText = "To play you must choose the requiered options that will be presented, also you must complete your profile, we use Health Kit to calculate the Stamina of your character in-game. In the game when an event appears you must press and hold the decission you choose. Remember each decission has consequences so decide carefully"
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        self.userProfile = UserModel()
        if (userProfile.userProfileName == nil && identifier == "toMissionSelection") {
            let alertController = UIAlertController(title: "Error", message:
                "Please create you profile before beginning a new game", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}
