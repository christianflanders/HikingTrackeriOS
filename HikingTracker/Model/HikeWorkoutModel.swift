//
//  HikeWorkoutModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

class HikeWorkout {
    
    var startDate: Date
    var endDate: Date?
    
    var distance: Double = 0
    var totalCalories: Double = 0
    
    init(start:Date) {
        self.startDate = start
    }
    
    
}
