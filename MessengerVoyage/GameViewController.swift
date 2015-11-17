//
//  GameViewController.swift
//  MessengerVoyage
//
//  Created by Iker on 10/11/15.
//  Copyright (c) 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var motor: GameMotor!
    var initGame: Array<AnyObject>!
    let userProfile = UserModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGame.append(userProfile)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventHappened:", name: "positiveEventOcurred", object: motor)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventHappened:", name: "negativeEventOcurred", object: motor)
        self.motor = GameMotor(parameters: initGame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func eventHappened(notification: NSNotification) {
        let data = notification.userInfo as NSDictionary!
        // Ventana de evento
        print(data)
    }

}
