//
//  GameMotor.swift
//  MessengerVoyage
//
//  Created by Iker on 26/10/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class GameMotor: NSObject {
    private var dayNightCicle: Float = 1.0
    private var distance: Float = 100.0
    private var permutationTable: [Float] = []
    private var permutationTablePosition: Int = 0
    private var masterTimer: NSTimer?
    
    var debugY = 0
    var debugN = 0
    
    override init() {
        super.init()
        for(var i = 0; i < 300; ++i) {
            permutationTable.append(Float(arc4random_uniform(100)))
        }
        //print(String(format: "%f", permutationTable[i]))
        masterTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("pickEvent"), userInfo: nil, repeats: true)
    }
    
    func pickEvent() {
        if(permutationTablePosition >= permutationTable.count - 1) {
            permutationTablePosition = 0
        }
        //print(self.permutationTable[self.permutationTablePosition] , " prob, test: " , self.permutationTable[self.permutationTablePosition + 1])
        if(self.permutationTable[permutationTablePosition + 1] < self.permutationTable[permutationTablePosition]) {
            //print("yes")
            permutationTablePosition++
            debugY++
        } else {
            //print("no")
            permutationTablePosition++
            debugN++
        }
        permutationTablePosition++
        if(permutationTablePosition >= 200) {
            self.pauseTimer()
        }
    }
    
    
    func pauseTimer() {
        self.masterTimer?.invalidate()
        print("yes: ", debugY, " no: ", debugN)
    }
}
