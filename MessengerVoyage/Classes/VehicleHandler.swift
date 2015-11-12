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
    private var fuel: Double!
    
    init(motor: GameMotor, selectedVehicle: String) {
        super.init()
        self.motor = motor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fuelDischarge:", name: "fuelDischarge", object: motor)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fuelCharge:", name: "fuelCharge", object: motor)

        //Tomar un entorno aleatorio del plist y su arte
        let path = NSBundle.mainBundle().pathForResource("VehicleList", ofType: "plist")
        let currentVehicle = NSDictionary.init(contentsOfFile: path!)?.objectForKey(selectedVehicle) as! NSDictionary
        self.fuel = currentVehicle.objectForKey("Fuel") as! Double
        self.name = currentVehicle.objectForKey("Name") as! String
        let buffs = currentVehicle.objectForKey("Buffs") as! NSDictionary
        for buff in buffs.allKeys {
            self.motor.alterMotor(buff as! String, value: buffs.objectForKey(buff) as! Double)
        }
    }
    
    func fuelDischarge(notification: NSNotification) {
        
    }
    
    func fuelCharge(notification: NSNotification) {
        
    }
}
