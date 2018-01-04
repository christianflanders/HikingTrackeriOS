//
//  HikeWorkoutFromHistory.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/3/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import CoreData
import HealthKit

class HikeWorkoutFromHistory {
    
    var startDate: Date
    
    var endDate: Date
    
    
    var caloriesBurned: Double
    
    var durationInSeconds: Double
    
    var totalElevationGainInMeters: Meters
    
    var totalCaloriesBurned: Calorie
    
    var avgPacePerHour: Meters
    
    var minAltitude: Meters
    
    var maxAltitude: Meters
    
    var timeUpHillInSeconds:Double
    
    var timeDownhillInSeconds: Double
    
    var storedLocations: [CLLocation]
    
    
    
}
