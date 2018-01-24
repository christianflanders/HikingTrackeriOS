//
//  Health Kit Utility.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/13/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitStore {
    
    init() {}

    
    func getUserDataFromHealthKit() -> UserInformationValues {
        var userInformationFromHealthKit = UserInformationValues()
        
        let healthKitStore = HKHealthStore()

        var weightFinished = false
        var heightFinished = false
        // If healthkit is authorized and exists
        guard HKHealthStore.isHealthDataAvailable() else {
            //display alert saying no health kit availble on device
            HealthKitAuthroizationSetup.authorizeHealthKit{ (done, error) in
                if error != nil {
                    print(error!)
                }
            }
            return userInformationFromHealthKit
        }
        //Set up asking HealthKit for the users weight, and set the value if there is one.
        let weightQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)

        let weightQuery = HKSampleQuery(sampleType: weightQuantityType!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if error != nil {
                print(error!)
                weightFinished = true
                return
            }
            
            // check for valid results
            guard let results = results else {
                print("No results of query")
                weightFinished = true
                return
            }
            
            // make sure there is at least one result to output
            if results.count == 0 {
                print("Zero samples")
                weightFinished = true
                return
            }
            
            // extract the one sample
            guard let bodymass = results[0] as? HKQuantitySample else {
                print("Type problem with weight")
                weightFinished = true
                return
            }
            let unit = HKUnit.gram()
            let weightInGrams = bodymass.quantity.doubleValue(for: unit)
            let weightInKilograms = weightInGrams * 0.001
            userInformationFromHealthKit.weightInKG = weightInKilograms
            weightFinished = true
        }
        
        healthKitStore.execute(weightQuery)
        
        //Set up asking HealthKit for the users height, and set the value if there is one.

        let heightQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        let heightQuery = HKSampleQuery(sampleType: heightQuantityType!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if error != nil {
                print(error!)
                heightFinished = true
                return
            }
            
            // check for valid results
            guard let results = results else {
                print("No results of query")
                heightFinished = true
                return
            }
            
            // make sure there is at least one result to output
            if results.count == 0 {
                print("Zero samples")
                heightFinished = true
                return
            }
            
            // extract the one sample
            guard let height = results[0] as? HKQuantitySample else {
                print("Type problem with height")
                heightFinished = true
                return
            }
            let unit = HKUnit.meter()
            let heightInMeters = height.quantity.doubleValue(for: unit)
            let heightInCentimeters = heightInMeters * 100
            userInformationFromHealthKit.heightInCentimeters = heightInCentimeters
            heightFinished = true
        }
        
        healthKitStore.execute(heightQuery)
        
        //Checks healthkit for the users biological sex, and sets accordingly. If no sex is set, the property will be set to nil to deal with later
        if let  biologicalSex = try? healthKitStore.biologicalSex() {
            switch biologicalSex.biologicalSex {
            case .female:
                userInformationFromHealthKit.gender = "Female"
                print("female")
            case .male:
                userInformationFromHealthKit.gender = "Male"
                print("male")
            case .other:
                userInformationFromHealthKit.gender = "Other"
                print("other")
            case .notSet:
                print("not set")
            }
        } else {
            print("no biological sex set")
        }
    
        // Checks HealthKit for the users birthday information. Once again, will be nil if none exists
        if let birthdate = try? healthKitStore.dateOfBirthComponents() {
            userInformationFromHealthKit.birthdate = birthdate.date
        }
        while weightFinished == false && heightFinished == false {

        }
        return userInformationFromHealthKit
    
    }
}
