//
//  Firebase Dictionary Strings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
struct FirebaseDict {
    
    var startDateKey = "startDate"
    var endDateKey = "endDate"
    var caloriesBurnedKey = "caloriesBurned"
    var durationInSecondsKey = "durationInSeconds"
    var totalElevationInMetersKey = "totalElevationInMeters"
    var avgPaceInMetersPerHourKey = "avgPaceInMetersPerHour"
    var minAltitudeInMetersKey = "minAltitudeInMeters"
    var maxAltitudeInMetersKey = "maxAltitudeInMeters"
    var timeUphillInSecondsKey = "timeUphillInSeconds"
    var timeDownhillInSecondsKey = "timeDownhillInSeconds"
    var storedLocationsKey = "storedLocationsKey"
}

struct Location {
    
    var latitudeKey = "latitude"
    var longitudeKey = "longitude"
    var altitudeKey = "altitude"
    var timestampKey = "timestamp"
    var speedInMetersPerSecondKey = "speedInMetersPerSecond"
    
    
}
