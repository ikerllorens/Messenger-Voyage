//
//  HealthManager.swift
//  UltraDelivery
//
//  Created by Iker on 16/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit
import HealthKit

class HealthManager: NSObject {
    let healthKitStore:HKHealthStore = HKHealthStore()
    private var heightSample: HKQuantitySample?
    private var weightSample: HKQuantitySample?
    private var weight: Double = -1
    private var height: Double = -1
    
    func authorizeHealthKit() -> Bool {
        let healthKitTypesToRead = Set(arrayLiteral: HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!)
        
        let healthKitTypesToWrite = Set<HKSampleType>()

        if (HKHealthStore.isHealthDataAvailable() == false)
        {
            return false
        }
        
        self.healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead, completion: {_,_ in return true})
        return true
    }
    
    func getAge() -> Int {
        do {
            let birthDate = try healthKitStore.dateOfBirth()
            let currentDate: NSDate = NSDate()
            let differenceFromDate = NSCalendar.currentCalendar().components(.Year, fromDate: birthDate, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))
            return differenceFromDate.year
        } catch {
            print("ERROR: Could not read Age from HealthKit")
            return -1
        }
    }
    
    func getWeight() -> Double {
        return self.weight
    }
    
    func getHeight() -> Double {
        return self.height
    }
    
    func getBloodType() -> Int {
        do {
            let bloodType = try healthKitStore.bloodType().bloodType
            var bloodTypeVal: Int = -1
            switch (bloodType) {
            case HKBloodType.APositive:
                bloodTypeVal = 0
                break
            case HKBloodType.ANegative:
                bloodTypeVal = 1
                break
            case HKBloodType.BPositive:
                bloodTypeVal = 2
                break
            case HKBloodType.BNegative:
                bloodTypeVal = 3
                break
            case HKBloodType.ABPositive:
                bloodTypeVal = 4
                break
            case HKBloodType.ABNegative:
                bloodTypeVal = 5
                break
            case HKBloodType.OPositive:
                bloodTypeVal = 6
                break
            case HKBloodType.ONegative:
                bloodTypeVal = 7
                break
            default:
                bloodTypeVal = -1
                break
            }
            return bloodTypeVal
        } catch {
            print("ERROR: Could not read Blood from HealthKit")
            return -1
        }
    }
    
    func updateHeight () {
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        self.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            if( error != nil ) {
                print("Error reading weight from HealthKit")
                return;
            }
            self.heightSample = mostRecentWeight as? HKQuantitySample;
            if let centimeters = self.heightSample?.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Centi)) {
                self.height = centimeters
                 NSNotificationCenter.defaultCenter().postNotificationName("heightUpdated", object: self)
            } else {
                self.height = -2
                NSNotificationCenter.defaultCenter().postNotificationName("heightUpdated", object: self)
            }
        });
    }
    
    func updateWeight () {
        // 1. Construct an HKSampleType for weight
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        // 2. Call the method to read the most recent weight sample
        self.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit")
                return;
            }
//            let kUnknownString   = "Unknown"
//            var weightLocalizedString = kUnknownString;
            // 3. Format the weight to display it on the screen
            self.weightSample = mostRecentWeight as? HKQuantitySample;
            if let kilograms = self.weightSample?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                self.weight = kilograms
                NSNotificationCenter.defaultCenter().postNotificationName("weightUpdated", object: self)
            } else {
                self.weight = -2
                NSNotificationCenter.defaultCenter().postNotificationName("weightUpdated", object: self)
            }
        });
    }
    
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        let past = NSDate.distantPast() 
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let _ = error {
                    completion(nil,error)
                    return;
                }
                
                // Get the first sample
                let mostRecentSample = results!.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
}
