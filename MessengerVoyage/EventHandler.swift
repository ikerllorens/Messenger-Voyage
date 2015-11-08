//
//  EventHandler.swift
//  MessengerVoyage
//
//  Created by Iker on 03/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class EventHandler: NSObject {
    private var currentEvent: NSDictionary!
    private var motor: GameMotor!
    
    init(motor: GameMotor) {
        super.init()
        self.motor = motor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventHappened:", name: "positiveEventOcurred", object: motor)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventHappened:", name: "negativeEventOcurred", object: motor)
    }
    
    func eventHappened(info: NSNotification) {
        
        let data = info.userInfo as NSDictionary!
        self.currentEvent = data

        if let inmediatteEffs: NSDictionary = self.currentEvent.objectForKey("InmediateEffects") as? NSDictionary {
            let queueInmediateEffectsEvents = NSOperationQueue()
            queueInmediateEffectsEvents.addOperationWithBlock() {
                for key in Array(inmediatteEffs.allKeys) {
                    self.motor.alterMotor(key as! String, value: inmediatteEffs.objectForKey(key) as! Double)
                }
            }
        }
    }
}
