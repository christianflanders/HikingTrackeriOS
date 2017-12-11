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
    
    
    
    let user = User()
    
    
    var startDate = Date()
    var endDate: Date?
    
    var distance: Double = 0
    var totalCaloriesBurned: Double {
        var totalCaloriesBurned: Double = 0.0
        guard let userWeight = user.weightInKilos else {return 0}
        let caloriesBurnedPerHourUphill = userWeight * hikeUphillMETValue
        let multiplierUphill = Double(timeTraveldUpHill) / 60.0
        totalCaloriesBurned += caloriesBurnedPerHourUphill * multiplierUphill
        
        let caloriesBurnedPerHourDownhill = userWeight * hikeDownhillMETValue
        let multiplierDownhill = Double(timeTraveledDownHill) / 60.0
        totalCaloriesBurned += caloriesBurnedPerHourDownhill * multiplierDownhill
        return totalCaloriesBurned
    }
    
    init() {
        
    }
    var duration: String {
        var stringMinutes = ""
        var stringSeconds = ""
        var stringHours = ""
        let calculatedSeconds = seconds % 60
        if calculatedSeconds < 10 {
            stringSeconds = String("0\(calculatedSeconds)")
        } else {
            stringSeconds = String(calculatedSeconds)
        }
        let calculatedMinutes = seconds / 60
        if calculatedMinutes < 10 {
            stringMinutes = String("0\(calculatedMinutes % 60)")
        } else {
            stringMinutes = String(calculatedMinutes % 60)
        }
        let calculatedHours = calculatedMinutes / 60
        if calculatedHours < 10 {
            stringHours = String("0\(calculatedHours)")
        } else {
            stringHours = String(calculatedHours)
        }
        let calculatedDurationString = "\(stringHours):\(stringMinutes):\(stringSeconds)"
        return calculatedDurationString
    }
    
    var seconds = 0
    var distanceTraveled: NSNumber?
    var timeTraveldUpHill = 0
    var timeTraveledDownHill = 0
    var pedometerData: CMPedometerData?
    var pace:NSNumber?
    var storedLocations = [CLLocation]()
    
    var lowestElevation = 0.0
    var highestElevation = 0.0
    let hikeUphillMETValue = 6.00
    let hikeDownhillMETValue = 2.8
    
    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
    }
    

    
}


enum hikeState {
    case notStarted
    case paused
    case started
    case finished
}
