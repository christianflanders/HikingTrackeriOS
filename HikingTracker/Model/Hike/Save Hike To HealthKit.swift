//
//  Save Hike To HealthKit.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/12/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import HealthKit

extension HikeInProgress {
    func storeHikeToHealthKit(name: String)  {
        
        let healthStore = HKHealthStore()
        
        let caloriesBurned = self.caloriesBurned
        let calorieUnit = HKUnit(from: .kilocalorie)
        let hkCalories = HKQuantity(unit: calorieUnit, doubleValue: caloriesBurned)
        
        let distanceInMeters = self.totalDistanceInMeters
        let distanceUnit = HKUnit(from: .meter)
        let hkDistance = HKQuantity(unit: distanceUnit, doubleValue: distanceInMeters)
        
        guard let startDate = self.startDate else {
            print("Problem getting start date")
            return
        }
        guard let endDate = self.endDate else {
            print("Problem getting start date")
            return
        }
        
        let duration = self.durationInSeconds
        
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

