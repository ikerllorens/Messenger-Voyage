//
//  GameMotor.swift
//  MessengerVoyage
//
//  Created by Iker on 31/10/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit
import Foundation

class GameMotor: NSObject {
    //private var dayNightCicle: Float = 1.0
    private var totalDistance: Double = 10000
    private var distance: Double = 10000.0
    private var velocity: Double = 1
    private var animationCycle: Int = 0
    private var permutationTable: [Double] = []
    private var permutationTablePosition: Int = 0
    private var temporalValues: Double = 0
    private var baseTime: Double = 1
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
    
    
    //MARK: Handlers
    //Objetos encargados de liberar carga al motor
    var eventHandler: EventHandler!
    var environmentHandler: EnvironmentHandler!
    var supportCharactersHandler: SupportCharactersHandler!
    var vehicleHandler: VehicleHandler!
    var userInfo: UserModel!
    
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
    init(parameters: Array<AnyObject>) {
        super.init()
        //Iniciar la tabla
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "continueTimer", name: "eventDecissionMade", object: nil)
        
        for(var i = 0; i < 601; ++i) {
            permutationTable.append(Double(arc4random_uniform(100)))
        }
        let path = NSBundle.mainBundle().pathForResource("EventList", ofType: "plist")
        self.eventHandler = EventHandler(motor: self)
        
        let missionParameters = parameters[0] as! NSDictionary
        self.environmentHandler = EnvironmentHandler(motor: self, startEnvironment: missionParameters.objectForKey("StartEnvironent") as! String)
        let modifiers = missionParameters.objectForKey("Modifiers") as! NSDictionary
        for modifier in modifiers.allKeys {
            alterMotor(modifier as! String, value: modifiers.objectForKey(modifier) as! Double)
        }
        if let distanceTemp = missionParameters.objectForKey("MissionDistance") as? Double {
            print("Distance", distanceTemp)
            self.distance = distanceTemp
            self.totalDistance = distanceTemp
        }
        
        self.supportCharactersHandler = SupportCharactersHandler(selectedCharacters: parameters[2] as! NSDictionary, motor: self)
        /*
        * Importante: La lave del diccionario del plist debe ser igual al nombre del vehiculo
        */
        self.vehicleHandler = VehicleHandler(motor: self, selectedVehicle: parameters[1] as! String)
        self.eventRootPositive = (NSArray(contentsOfFile: path!)!.objectAtIndex(0) as? NSDictionary)
        self.eventRootNegative = (NSArray(contentsOfFile: path!)!.objectAtIndex(1) as? NSDictionary)
        
        self.userInfo = parameters[3] as! UserModel
        self.userInfo.buildStamina()
        
        self.🕑 = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.baseTime), target: self, selector: Selector("pickEvent"), userInfo: nil, repeats: true) //5 segundos, base. Loops de animacion
        print("Start!!!!!!!!!")
    }
    
    func pickEvent() {
        print("Distance Check", self.distance)
        //self.moveTablePosition()
        if(self.permutationTable[permutationTablePosition] < self.baseProbabilityEvent) {
            //Sucedio Evento
            self.🕑?.invalidate()
            self.🕑?.invalidate()
            self.🕑 = nil
            //let queue = NSOperationQueue()
            //queue.addOperationWithBlock() {
            self.moveTablePosition()
            
            //Prob 50% 50% de evento + o -, prob se modifica por lo menos por el vehiculo y por el entorno y por otros eventos. Cambios ligero
            if(self.permutationTable[self.permutationTablePosition] < self.baseNegPosEventProb) {
                //Evento Positivo
                //let queueForEventType = NSOperationQueue()
                //queueForEventType.addOperationWithBlock() {
                
                self.moveTablePosition()
                //Idealmente 100, blindaje ante errores de suma
                let sumPositiveSubtypesProb = self.probabilityDiscovery + self.probabilityClearWeather + self.probabilityMerchant + self.probabilityWildCardPos
                let normalizedValue = self.permutationTable[self.permutationTablePosition] * (sumPositiveSubtypesProb/100)
                var positiveEventSubtype: String?
                
                if ((normalizedValue >= 0) && (normalizedValue <= (0 + self.probabilityDiscovery))) {
                    //W Variable
                    positiveEventSubtype = "Discovery"
                    self.debugEvW++
                } else if ((normalizedValue > (0 + self.probabilityDiscovery)) && (normalizedValue <= (0 + self.probabilityDiscovery + self.probabilityMerchant))) {
                    //X variable
                    positiveEventSubtype = "Merchant"
                    self.debugEvX++
                } else if ((normalizedValue > (0 + self.probabilityDiscovery + self.probabilityMerchant)) && (normalizedValue <= (0 + self.probabilityDiscovery + self.probabilityMerchant + self.probabilityClearWeather))) {
                    //Y variable
                    positiveEventSubtype = "ClearWeather"
                    self.debugEvY++
                } else if ((normalizedValue > (0 + self.probabilityDiscovery + self.probabilityMerchant + self.probabilityClearWeather)) && (normalizedValue <= (0 + self.probabilityDiscovery + self.probabilityMerchant + self.probabilityClearWeather + self.probabilityWildCardPos))) {
                    //Z variable
                    positiveEventSubtype = "WildCardPos"
                    self.debugEvZ++
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
                
                self.debugPos++
                
            } else {
                //Evento negativo
                
                //                    let queueForEventType = NSOperationQueue()
                //                    queueForEventType.addOperationWithBlock() {
                
                self.moveTablePosition()
                
                //Idealmente 100, blindaje ante errores de suma
                let sumNegativeSubtypesProb = self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather + self.probabilityWildCardNeg
                let normalizedValue = self.permutationTable[self.permutationTablePosition] * (sumNegativeSubtypesProb/100)
                var negativeEventSubtype: String?
                
                if ((normalizedValue >= 0) && (normalizedValue <= (0 + self.probabilityAttack))) {
                    //A Variable
                    negativeEventSubtype = "Attack"
                    self.debugEvA++
                } else if ((normalizedValue > (0 + self.probabilityAttack)) && (normalizedValue <= (0 + self.probabilityAttack + self.probabilityFailure))) {
                    //B variable
                    negativeEventSubtype = "Failure"
                    self.debugEvB++
                } else if ((normalizedValue > (0 + self.probabilityAttack + self.probabilityFailure)) && (normalizedValue <= (0 + self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather))) {
                    //C variable
                    negativeEventSubtype = "BadWeather"
                    self.debugEvC++
                } else if ((normalizedValue > (0 + self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather)) && (normalizedValue <= (0 + self.probabilityAttack + self.probabilityFailure + self.probabilityBadWeather + self.probabilityWildCardNeg))) {
                    //D variable
                    negativeEventSubtype = "WildCardNeg"
                    self.debugEvD++
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
                self.debugNeg++
                //                    }
            }
            
            self.moveTablePosition()
            self.debugY++
            //        }
        } else {
            //No sucedio evento
            self.moveTablePosition()
            debugN++
        }
        
        if(self.distance <= 0) {
            self.pauseTimer()
        } else {
            self.distance = self.distance - velocity
        }
        
    }
    
    func alterMotor(parameter: String, value: Double) {
        switch (parameter) {
        case "modifyBaseProbability":
            print("baseProbabilityModified", value)
            if (self.baseProbabilityEvent <= 100) {
                self.baseProbabilityEvent = self.baseProbabilityEvent * value
            }
            break
        case "modifyNegativeEvents":
            print("negativeEventsModified", value)
            if (self.baseNegPosEventProb <= 100) {
                self.baseNegPosEventProb = self.baseNegPosEventProb * value
            }
            break
        case "modifyAttackProbability":
            print("attackProbabilityModified", value)
            if (self.probabilityAttack <= 100) {
                self.probabilityAttack = self.probabilityAttack * value
            }
            break
        case "modifyFailureProbability":
            print("failureProbabilityModified", value)
            if (self.probabilityFailure <= 100) {
                self.probabilityFailure = self.probabilityFailure * value
            }
            break
        case "modifyBadWeatherProbability":
            print("badWeatherProbabilityModified", value)
            if (self.probabilityBadWeather <= 100) {
                self.probabilityBadWeather = self.probabilityBadWeather * value
            }
            break
        case "modifyDiscoveryProbability":
            print("discoveryProbabilityModified", value)
            if (self.probabilityDiscovery <= 100) {
                self.probabilityDiscovery = self.probabilityDiscovery * value
            }
            break
        case "modifyClearWeatherProbability":
            print("ClearWeatherProbabilitymodified", value)
            if (self.probabilityClearWeather <= 100) {
                self.probabilityClearWeather = self.probabilityClearWeather * value
            }
            break
        case "modifyMovementVelocity":
            print("VelocityModified", value)
            self.velocity = self.velocity * value
            break
        case "reduceCharactersHealth":
            print("CharacterHealth Reduced", value)
            self.supportCharactersHandler.reduceHealthBy(value)
            self.userInfo.userStamina = self.userInfo.userStamina - value
            if (self.userInfo.userStamina <= 0) {
                NSNotificationCenter.defaultCenter().postNotificationName("gameEnded", object: self, userInfo: ["reason":"dead"])
                self.pauseTimer()
            }
            break
        case "increaseCharactersHealth":
            print("CharacterHealth Increased", value)
            self.supportCharactersHandler.increaseHealthBy(value)
            self.userInfo.userStamina = self.userInfo.userStamina - value
            break
        default:
            print("invalid parameter:", parameter)
            break
        }
    }
    
    //TODO: Eliminar prints
    func pauseTimer() {
        self.🕑?.invalidate()
        print("yes: ", debugY, " no: ", debugN)
        print("+: ", debugPos, " -: ", debugNeg)
        print("W: ", debugEvW, " X: ", debugEvX, " Y: ", debugEvY, " Z: ", debugEvZ)
        print("A: ", debugEvA, " B: ", debugEvB, " C: ", debugEvC, " D: ", debugEvD)
        print("ProbBase: ", self.baseProbabilityEvent)
        self.animationCycle = 0
        
        NSNotificationCenter.defaultCenter().postNotificationName("gameEnded", object: self, userInfo: ["reason":"arrived"])
    }
    
    func progressPercentage() -> Double {
        return (1 - (self.distance/self.totalDistance))
    }
    
    func continueTimer() {
        if (self.🕑 == nil) {
            self.🕑 = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.baseTime), target: self, selector: Selector("pickEvent"), userInfo: nil, repeats: true)
        }
    }
    
    private func moveTablePosition() {
        self.permutationTablePosition++
        if(permutationTablePosition >= 599
            ) {
                permutationTable[permutationTable.count - 1] = self.temporalValues
                permutationTablePosition = 0
        }
    }
}