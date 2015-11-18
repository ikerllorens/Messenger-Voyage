//
//  UserModel.swift
//  UltraDelivery
//
//  Created by Iker on 16/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit
import HealthKit

class UserModel: NSObject {
    var userProfileBloodType: Int!
    var userStamina: Double!
    var userProfileName: String!
    var userProfileAge: Int!
    var userProfileHeight: Double!
    var userProfileWeight: Double!
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveData", name: "gamePause", object: nil)
        self.loadData()
    }
    
    func saveData() {
        let saveArray = [userProfileBloodType, userProfileName, userProfileAge, userProfileHeight, userProfileWeight]
        NSUserDefaults.standardUserDefaults().setObject(saveArray, forKey: "userProfile")
        print("User Data Saved")
    }
    
    func loadData() {
        if let loadArray = NSUserDefaults.standardUserDefaults().objectForKey("userProfile") as? NSArray {
            self.userProfileBloodType = loadArray.objectAtIndex(0) as! Int
            self.userProfileName = loadArray.objectAtIndex(1) as! String
            self.userProfileAge = loadArray.objectAtIndex(2) as! Int
            self.userProfileHeight = loadArray.objectAtIndex(3) as! Double
            self.userProfileWeight = loadArray.objectAtIndex(4) as! Double
            print("User Data Loaded")
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("noUserProfileDetected", object: self)
        }
    }
    
    func buildStamina() {
        let ageSquared =  Double((self.userProfileAge * self.userProfileAge))
        let ageStaminaFactor = (9650 - (625 * Double(self.userProfileAge)) + (11 * ageSquared)) * 0.0011111
        self.userStamina = (self.userProfileWeight * self.userProfileHeight) / ageStaminaFactor
    }
}
