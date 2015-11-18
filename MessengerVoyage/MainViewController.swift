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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "forceProfile", name: "noUserProfileDetected",object: nil)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func forceProfile() {
        //let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc: UserProfileViewController = storyboard.instantiateViewControllerWithIdentifier("userProfileView") as! UserProfileViewController
        
        //self.presentViewController(vc, animated: true, completion: nil)
    }
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

}
