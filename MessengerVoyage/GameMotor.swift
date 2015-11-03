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
    private var distance: Double = 10000.0
    private var animationCycle: Int = 0
    private var permutationTable: [Double] = []
    private var permutationTablePosition: Int = 0
    private var temporalValues: Double = 0
    private var baseTime: Double = 0.001
    private var 🕑: NSTimer?
    
    //Si es mayor habra mas eventos, si es menor habra menos eventos
    private var baseProbabilityEvent: Double = 21
    //Si es mayor habra mas eventos +, si es menor habra mas eventos -
    private var baseNegPosEventProb: Double = 51
    
    //MARK: Arreglos de eventos
    private var eventRootPositive: NSDictionary?
    private var eventRootNegative: NSDictionary?
    
    //MARK: Subcatergorias de Eventos Neg
    //Cuidado con estas 4 probabilidades, siempre deben sumar 100. Corresponden a eventos negativos
    private var probabilityAttack: Double = 25
    private var probabilityFailure: Double = 25
    private var probabilityBadWeather: Double = 25
    private var probabilityWildCardNeg: Double = 25
    
    //MARK: Subcatergorias de Eventos Pos
    //Cuidado con estas 4 probabilidades, siempre deben sumar 100. Corresponden a eventos positivos
    private var probabilityDiscovery: Double = 25
    private var probabilityMerchant: Double = 25
    private var probabilityClearWeather: Double = 25
    private var probabilityWildCardPos: Double = 25
    
    //MARK: Debug variable
    //TODO: Borrar
    var debugY = 0
    var debugN = 0
    var debugPos = 0
    var debugNeg = 0
    var debugEvA = 0
    var debugEvB = 0
    var debugEvC = 0
    var debugEvD = 0
    var debugEvW = 0
    var debugEvX = 0
    var debugEvY = 0
    var debugEvZ = 0
    
    //MARK: Metodos
    override init() {
        super.init()
        //Iniciar la tabla
        for(var i = 0; i < 601; ++i) {
            permutationTable.append(Double(arc4random_uniform(101)))
        }
        let path = NSBundle.mainBundle().pathForResource("EventList", ofType: "plist")
        self.eventRootPositive = (NSArray(contentsOfFile: path!)!.objectAtIndex(0) as? NSDictionary)
        self.eventRootNegative = (NSArray(contentsOfFile: path!)!.objectAtIndex(1) as? NSDictionary)
        🕑 = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.baseTime), target: self, selector: Selector("pickEvent"), userInfo: nil, repeats: true) //5 segundos, base. Loops de animacion
    }

    func pickEvent() {
        //self.moveTablePosition()
        if(self.permutationTable[permutationTablePosition] < self.baseProbabilityEvent) {
            //Sucedio Evento
            self.moveTablePosition()
            
            //Prob 50% 50% de evento + o -, prob se modifica por lo menos por el vehiculo y por el entorno y por otros eventos. Cambios ligero
            if(self.permutationTable[permutationTablePosition] < self.baseNegPosEventProb) {
                self.moveTablePosition()
                //Evento Positivo
                
                //Idealmente 100, blindaje ante errores de suma
                let sumPositiveSubtypesProb = self.probabilityDiscovery + self.probabilityClearWeather + self.probabilityMerchant + self.probabilityWildCardPos
                let normalizedValue = self.permutationTable[permutationTablePosition] * (sumPositiveSubtypesProb/100)
                var positiveEventSubtype: String?
                
                if ((normalizedValue >= 0) && (normalizedValue <= (0 + self.probabilityDiscovery))) {
                    //W Variable
                    positiveEventSubtype = "Discovery"
                    debugEvW++
                } else if ((normalizedValue > (0 + self.probabilityDiscovery)) && (normalizedValue <= (0 + self.probabilityDiscovery + self.probabilityMerchant))) {
                    //X variable
                    positiveEventSubtype = "Merchant"
                    debugEvX++
                } else if ((normalizedValue > (0 + self.probabilityDiscovery + self.probabilityMerchant)) && (normalizedValue <= (0 + self.probabilityDiscovery + self.probabilityMerchant + self.probabilityClearWeather))) {
                    //Y variable
                    positiveEventSubtype = "ClearWeather"
                    debugEvY++
                } else if ((normalizedValue > (0 + self.probabilityDiscovery + self.probabilityMerchant + self.probabilityClearWeather)) && (normalizedValue <= (0 + self.probabilityDiscovery + self.probabilityMerchant + self.probabilityClearWeather + self.probabilityWildCardPos))) {
                    //Z variable
                    positiveEventSubtype = "WildCardPos"
                    debugEvZ++
                } else {
                    //TODO: Borrar impresion debug
                    print("Error on event recognition")
                    return
                }
                
                let subcategoryEvent: NSArray = self.eventRootPositive!.objectForKey(positiveEventSubtype!) as! NSArray
                let positiveEventIndex: Int = Int(arc4random_uniform(UInt32(subcategoryEvent.count)))
                
                if let eventPositive = subcategoryEvent[positiveEventIndex] as? NSDictionary {
                    NSNotificationCenter.defaultCenter().postNotificationName("positiveEventOcurred", object: self, userInfo: eventPositive as [NSObject : AnyObject])
                }
                
                debugPos++
            } else {
                //Evento negativo
                self.moveTablePosition()
                
                //Idealmente 100, blindaje ante errores de suma
                let sumNegativeSubtypesProb = self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather + self.probabilityWildCardNeg
                let normalizedValue = self.permutationTable[permutationTablePosition] * (sumNegativeSubtypesProb/100)
                var negativeEventSubtype: String?
                
                if ((normalizedValue >= 0) && (normalizedValue <= (0 + self.probabilityAttack))) {
                    //A Variable
                    negativeEventSubtype = "Attack"
                    debugEvA++
                } else if ((normalizedValue > (0 + self.probabilityAttack)) && (normalizedValue <= (0 + self.probabilityAttack + self.probabilityFailure))) {
                    //B variable
                    negativeEventSubtype = "Failure"
                    debugEvB++
                } else if ((normalizedValue > (0 + self.probabilityAttack + self.probabilityFailure)) && (normalizedValue <= (0 + self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather))) {
                    //C variable
                    negativeEventSubtype = "BadWeather"
                    debugEvC++
                } else if ((normalizedValue > (0 + self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather)) && (normalizedValue <= (0 + self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather + self.probabilityWildCardNeg))) {
                    //D variable
                    negativeEventSubtype = "WildCardNeg"
                    debugEvD++
                } else {
                    //TODO: Borrar impresion debug
                    print("Error on event recognition")
                    return
                }
                
                let subcategoryEvent: NSArray = self.eventRootNegative!.objectForKey(negativeEventSubtype!) as! NSArray
                let negativeEventIndex: Int = Int(arc4random_uniform(UInt32(subcategoryEvent.count)))
                
                if let eventNegative = subcategoryEvent[negativeEventIndex] as? NSDictionary {
                    NSNotificationCenter.defaultCenter().postNotificationName("negativeEventOcurred", object: self, userInfo: eventNegative as [NSObject : AnyObject])
                }
//                //print("Negative")
                debugNeg++
            }
            
            self.moveTablePosition()
            debugY++
        } else {
            //No sucedio evento
            self.moveTablePosition()
            debugN++
        }
        self.animationCycle++
        if(self.animationCycle >= 7000) {
            self.pauseTimer()
        }
    }
    
    
    func pauseTimer() {
        self.🕑?.invalidate()
        print("yes: ", debugY, " no: ", debugN)
        print("+: ", debugPos, " -: ", debugNeg)
        print("W: ", debugEvW, " X: ", debugEvX, " Y: ", debugEvY, " Z: ", debugEvZ)
        print("A: ", debugEvA, " B: ", debugEvB, " C: ", debugEvC, " D: ", debugEvD)

    }
    
    private func moveTablePosition() {
        self.permutationTablePosition++
        if(permutationTablePosition >= permutationTable.count - 1) {
            permutationTable[permutationTable.count - 1] = self.temporalValues
            permutationTablePosition = 0
        }
    }
}
