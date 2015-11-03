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
    private var bloodType: Int
    private var height: Float
    private var weight: Float
    private var BMI: Float
    private var age: Int
    
    init(BloodType: Int, Height: Float, Weight: Float, Age: Int) {
        self.bloodType = BloodType
        self.height = Height
        self.weight = Weight
        self.BMI = weight/(height * height)
        self.age = Age
    }
}
