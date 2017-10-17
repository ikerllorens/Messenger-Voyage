//
//  VehicleHandler.swift
//  UltraDelivery
//
//  Created by Iker on 11/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class VehicleHandler: NSObject {
    private var motor: GameMotor!
    private var name: String!
    private var velocity: Double!
    var currentVehicle: NSDictionary!
    
    init(motor: GameMotor, selectedVehicle: String) {
        super.init()
        self.motor = motor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fuelDischarge:", name: "fuelDischarge", object: motor)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fuelCharge:", name: "fuelCharge", object: motor)

        //Tomar un entorno aleatorio del plist y su arte
        let path = NSBundle.mainBundle().pathForResource("VehicleList", ofType: "plist")
        self.currentVehicle = NSDictionary.init(contentsOfFile: path!)?.objectForKey(selectedVehicle) as! NSDictionary
        
        self.velocity = self.currentVehicle.objectForKey("Velocity") as! Double
        self.name = self.currentVehicle.objectForKey("Name") as! String
        let buffs = self.currentVehicle.objectForKey("Buffs") as! NSDictionary
        self.motor.alterMotor("modifyMovementVelocity", value: self.velocity)
        for buff in buffs.allKeys {
            self.motor.alterMotor(buff as! String, value: buffs.objectForKey(buff) as! Double)
        }
    }
    
    func fuelDischarge(notification: NSNotification) {
        
    }
    
    func fuelCharge(notification: NSNotification) {
        
    }
}
