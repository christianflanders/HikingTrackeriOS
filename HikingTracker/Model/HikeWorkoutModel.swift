//
//  HikeWorkoutModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

class HikeWorkout {
    
    var startDate = Date()
    var endDate: Date?
    
    var distance: Double = 0
    var totalCaloriesBurned: Double {
        var totalCaloriesBurned: Double = 0.0
        if let timeTraveledUphill = timeTraveldUpHill {
            let caloriesBurnedPerHour = weightInKG * hikeUphillMETValue
            let multiplier = timeTraveledUphill / 60.0
            totalCaloriesBurned += caloriesBurnedPerHour * multiplier
        }
        if let timeTraveledDownhill = timeTraveledDownHill {
            let caloriesBurnedPerHour = weightInKG * hikeDownhillMETValue
            let multiplier = timeTraveledDownhill / 60.0
            totalCaloriesBurned += caloriesBurnedPerHour * multiplier
        }
        return totalCaloriesBurned
    }
    
    init() {
        
    }
    
    var seconds = 0
    var distanceTraveled: NSNumber?
    var timeTraveldUpHill: Double?
    var timeTraveledDownHill:Double?
    var pedometerData: CMPedometerData?
    var pace:NSNumber?
    var storedLocations = [CLLocation]()
    
    
    var hikeUphillMETValue = 6.00
    var hikeDownhillMETValue = 2.8
    var testWeightInKG = 163.293
    
    var weightInKG: Double {
        let defaults = UserDefaults.standard
        let weight = defaults.double(forKey: "weight")
        print("Weight is", weight)
        return weight
    }
    
}


enum hikeState {
    case notStarted
    case paused
    case started
    case finished
}
