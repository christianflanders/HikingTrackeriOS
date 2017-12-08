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
    var totalCalories: Double = 0
    
    init() {
        
    }
    
    var seconds = 0
    var distanceTraveled: NSNumber?
    var pedometerData: CMPedometerData?
    var pace:NSNumber?
    var storedLocations = [CLLocation]()
    
}


enum hikeState {
    case notStarted
    case paused
    case started
    case finished
}
