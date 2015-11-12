//
//  SupportCharactersHandler.swift
//  UltraDelivery
//
//  Created by Iker on 10/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class SupportCharactersHandler: NSObject {
    private var characters: [SupportCharacters] = []
    private var motor: GameMotor!
    
    init(selectedCharacters: NSDictionary, motor: GameMotor) {
        super.init()
        self.motor =  motor
        for selectedCh in selectedCharacters.allKeys {
            if let charInfo = selectedCharacters.objectForKey(selectedCh) as? NSDictionary {
                characters.append(SupportCharacters(characterClass: charInfo.objectForKey("Class") as! String, characterName: charInfo.objectForKey("Name") as! String))
                for buff in (self.characters.last?.buffs.allKeys)! {
                    self.motor.alterMotor(buff as! String, value: self.characters.last?.buffs.objectForKey(buff) as! Double)
                }
            }
        }
    }
    
    func reduceHealthBy(healthDecreas: Double) {
        
    }
}
