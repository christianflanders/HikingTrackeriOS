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
    
    func storeHikeToHealthKit(_ hikeWorkout: HikeWorkout, name: String)  {
        
        let healthStore = HKHealthStore()
        
        let caloriesBurned = hikeWorkout.totalCaloriesBurned
        let calorieUnit = HKUnit(from: .kilocalorie)
        let hkCalories = HKQuantity(unit: calorieUnit, doubleValue: caloriesBurned)
        
        let distanceInMeters = hikeWorkout.totalDistanceTraveled
        let distanceUnit = HKUnit(from: .meter)
        let hkDistance = HKQuantity(unit: distanceUnit, doubleValue: distanceInMeters!)
        
        guard let startDate = hikeWorkout.startDate else {
            print("Problem getting start date")
            return
        }
        guard let endDate = hikeWorkout.endDate else {
            print("Problem getting start date")
            return
        }
        
        let duration = hikeWorkout.calculatedDuration
        
        let workout = HKWorkout(activityType: .hiking, start: startDate, end: endDate, duration: duration,
                                totalEnergyBurned: hkCalories, totalDistance: hkDistance, device: HKDevice.local(), metadata: nil)
        
        healthStore.save(workout) { (_, error) in
            if error == nil {
                print("Success saving workout to health kit store!")
            } else {
                
            }
        }
        
    }
    
    func getUserDataFromHealthKit() -> UserInformationValues {
        var userInformationFromHealthKit = UserInformationValues()
        
        let healthKitStore = HKHealthStore()
        
        // If healthkit is authorized and exists
        guard HKHealthStore.isHealthDataAvailable() else {
            //display alert saying no health kit availble on device
            HealthKitAuthroizationSetup.authorizeHealthKit{ (done, error) in
                if error != nil {
                    print(error)
                }
            }
            return userInformationFromHealthKit
        }
        //Set up asking HealthKit for the users weight, and set the value if there is one.
        let weightQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)

        let weightQuery = HKSampleQuery(sampleType: weightQuantityType!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if error != nil {
                print(error)
                return
            }
            
            // check for valid results
            guard let results = results else {
                print("No results of query")
                return
            }
            
            // make sure there is at least one result to output
            if results.count == 0 {
                print("Zero samples")
                return
            }
            
            // extract the one sample
            guard let bodymass = results[0] as? HKQuantitySample else {
                print("Type problem with weight")
                return
            }
            let unit = HKUnit.gram()
            let weightInGrams = bodymass.quantity.doubleValue(for: unit)
            let weightInKilograms = weightInGrams * 0.001
            userInformationFromHealthKit.weightInKG = weightInKilograms
        }
        
        healthKitStore.execute(weightQuery)
        
        //Set up asking HealthKit for the users height, and set the value if there is one.

        let heightQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        let heightQuery = HKSampleQuery(sampleType: heightQuantityType!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if error != nil {
                print(error)
                return
            }
            
            // check for valid results
            guard let results = results else {
                print("No results of query")
                return
            }
            
            // make sure there is at least one result to output
            if results.count == 0 {
                print("Zero samples")
                return
            }
            
            // extract the one sample
            guard let height = results[0] as? HKQuantitySample else {
                print("Type problem with height")
                return
            }
            let unit = HKUnit.meter()
            userInformationFromHealthKit.heightInMeters = height.quantity.doubleValue(for: unit)
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
        
        return userInformationFromHealthKit
    
    }
}
