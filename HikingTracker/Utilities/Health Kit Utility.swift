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
    
    func storeHikeToHealthKit(_ hikeWorkout: HikeWorkout, name: String) {
        
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
        
        let duration = endDate.timeIntervalSince(startDate)
        
        let workout = HKWorkout(activityType: .hiking, start: startDate, end: endDate, duration: duration,
                                totalEnergyBurned: hkCalories, totalDistance: hkDistance, device: HKDevice.local(), metadata: nil)
        
        healthStore.save(workout) { (_, error) in
            if error == nil {
                print("Success saving workout to health kit store!")
            } else {
                
            }
            
        }
        
    }

}
