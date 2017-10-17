//
//  HelpViewController.swift
//  UltraDelivery
//
//  Created by Iker on 22/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBOutlet weak var isn: UITextView!
    var tempText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(tempText != nil) {
            isn.text = tempText
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func d(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
