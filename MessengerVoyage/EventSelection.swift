//
//  EventSelection.swift
//  UltraDelivery
//
//  Created by Iker on 20/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class EventSelection: UITextView {

    var selectPercentage: Double = 0
    
    func inflate() {
        if(self.selectPercentage < 1) {
            self.selectPercentage = self.selectPercentage + 0.04
            self.backgroundColor = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: Float(self.selectPercentage))
        } else {
            
        }
    }
    
    func returnNormalState() {
        self.selectPercentage = 0
        self.backgroundColor = UIColor.whiteColor()
    }

}
