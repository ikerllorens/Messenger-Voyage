//
//  Environment.swift
//  MessengerVoyage
//
//  Created by Iker on 27/10/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class EnvironmentHandler: NSObject {
    private var motor: GameMotor!
    private var currentEnvironment: NSDictionary!
    
    init(motor: GameMotor, startEnvironment: String) {
        super.init()
        self.motor = motor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeEnvironment:", name: "environmentChange", object: motor)
        //Tomar un entorno aleatorio del plist y su arte
        let path = NSBundle.mainBundle().pathForResource("EnvironmentList", ofType: "plist")
        self.currentEnvironment = NSDictionary.init(contentsOfFile: path!)?.objectForKey(startEnvironment) as! NSDictionary
        print(self.currentEnvironment.objectForKey("Name")!,"!")
        self.environmentMotorChanges()
    }
    
    func changeEnvironment(newEnvironment: String) {
        let path = NSBundle.mainBundle().pathForResource("EnvironmentList", ofType: "plist")
        self.currentEnvironment = NSDictionary.init(contentsOfFile: path!)?.objectForKey(newEnvironment) as! NSDictionary
        self.environmentMotorChanges()
    }
    
    func environmentMotorChanges() {
        if let modifiers = currentEnvironment.objectForKey("Modifiers") as? NSDictionary {
            //            let queueEnvironment = NSOperationQueue()
            //            queueEnvironment.addOperationWithBlock() {
            for modifier in modifiers.allKeys {
                let modifierVal = modifiers.objectForKey(modifier) as! Double
                self.motor.alterMotor(modifier as! String, value: modifierVal)
            }
            //            }
        }
    }
}
