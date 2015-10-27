//
//  GameMotor.swift
//  MessengerVoyage
//
//  Created by Iker on 26/10/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit
import Foundation

//TODO clase de entorno.
//TODO objeto de evento

class GameMotor: NSObject {
    //private var dayNightCicle: Float = 1.0
    private var distance: Float = 10000.0
    private var animationCycle: Int = 0
    private var permutationTable: [Float] = []
    private var permutationTablePosition: Int = 0
    private var temporalValues: Float = 0
    private var baseTime: Float = 0.01
    private var 🕑: NSTimer?
    private var baseProbabilityEvent: Float = 21
    private var baseNegPosEventProb: Float = 51
    
    var debugY = 0
    var debugN = 0
    var debugPos = 0
    var debugNeg = 0
    
    override init() {
        super.init()
        for(var i = 0; i < 300; ++i) {
            permutationTable.append(Float(arc4random_uniform(100)))
        }
        //print(String(format: "%f", permutationTable[i]))
        🕑 = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.baseTime), target: self, selector: Selector("pickEvent"), userInfo: nil, repeats: true) //5 segundos, base. Loops de animacion
    }

    func pickEvent() {
        if(permutationTablePosition >= permutationTable.count - 1) {
            permutationTable[permutationTable.count - 1] = self.temporalValues
            permutationTablePosition = 0
        }
        
        //Ratio YES event/NO event  1.3/1.4
        if(self.permutationTable[permutationTablePosition] < self.baseProbabilityEvent) {
            self.permutationTable[permutationTablePosition] = self.temporalValues
            
            permutationTablePosition++
            if(permutationTablePosition >= permutationTable.count - 1) {
                permutationTable[permutationTable.count - 1] = self.temporalValues
                permutationTablePosition = 0
            }
            if(self.permutationTable[permutationTablePosition]
                < self.baseNegPosEventProb) {
                //print("Positive")
                debugPos++
            } else {
                //print("Negative")
                debugNeg++
            }
            
            permutationTablePosition++
            self.temporalValues = self.permutationTable[permutationTablePosition]
            self.permutationTable[permutationTablePosition] = self.permutationTable[permutationTablePosition] * 0.76// prob del vehiculo
            
            //Prob 50% 50% de evento + o -, prob se modifica por lo menos por el vehiculo y por el entorno y por otros eventos. Cambios ligero
            debugY++
        } else {
            self.permutationTable[permutationTablePosition] = self.temporalValues
            permutationTablePosition++
            self.temporalValues = self.permutationTable[permutationTablePosition]
            self.permutationTable[permutationTablePosition] = self.permutationTable[permutationTablePosition] * 1.3
            debugN++
        }
        self.animationCycle++
        if(self.animationCycle >= 5000) {
            self.pauseTimer()
        }
    }
    
    
    func pauseTimer() {
        self.🕑?.invalidate()
        print("yes: ", debugY, " no: ", debugN)
        print("+: ", debugPos, " -: ", debugNeg)
    }
}
