//
//  EndGameViewController.swift
//  UltraDelivery
//
//  Created by Iker on 22/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var endResume: UILabel!
    var textResume: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endResume.text = self.textResume
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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