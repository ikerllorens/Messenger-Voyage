//
//  SupportCharacters.swift
//  MessengerVoyage
//
//  Created by Iker on 10/12/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit


//Solo support
class SupportCharacters: NSObject {
    private var bloodType: Int!
    private var height: Double!
    private var weight: Double!
    var stamina: Double!
    private var age: Double!
    private var name: String!
    var buffs: NSDictionary!
    
    init(characterClass: String, characterName: String) {
        let path = NSBundle.mainBundle().pathForResource("SupportCharactersList", ofType: "plist")
        if let classArray = NSDictionary(contentsOfFile: path!)?.objectForKey(characterClass) as? NSDictionary {
            if let character = classArray.objectForKey(characterName) as? NSDictionary {
                self.name = character.objectForKey("Name") as! String
                self.bloodType = character.objectForKey("BloodType") as! Int
                self.height = character.objectForKey("Height") as! Double
                self.weight = character.objectForKey("Weight") as! Double
                self.age = character.objectForKey("Age") as! Double
                let ageSquared =  (self.age * self.age)
                let ageStaminaFactor = (9650 - (625 * self.age) + (11 * ageSquared)) * 0.0011111
                self.stamina = (self.weight * self.height) / ageStaminaFactor //25 es la edad optima
                //(5200 - 365 x + 7 x^2)* 1/450
                //0.00111111 (9650. - 625. x + 11. x^2)
                self.stamina = self.stamina / 10
                self.buffs = character.objectForKey("Buffs") as! NSDictionary
                print(self.stamina)
            }
        }
    }
}
