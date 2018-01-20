//
//  Firebase Dictionary Strings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
struct FirebaseDict {
    
    let startDateKey = "startDate"
    let endDateKey = "endDate"
    let caloriesBurnedKey = "caloriesBurned"
    let durationInSecondsKey = "durationInSeconds"
    let totalElevationInMetersKey = "totalElevationInMeters"
    let avgPaceInMetersPerHourKey = "avgPaceInMetersPerHour"
    let minAltitudeInMetersKey = "minAltitudeInMeters"
    let maxAltitudeInMetersKey = "maxAltitudeInMeters"
    let timeUphillInSecondsKey = "timeUphillInSeconds"
    let timeDownhillInSecondsKey = "timeDownhillInSeconds"
    let storedLocationsKey = "storedLocationsKey"
    let totalDistanceInMetersKey = "totalDistanceInMeters"
    let hikeNameKey = "hikeName"
    let storedPaces = "storedPaces"
    
}

struct Location {
    
    let latitudeKey = "latitude"
    let longitudeKey = "longitude"
    let altitudeKey = "altitude"
    let timestampKey = "timestamp"
    let speedInMetersPerSecondKey = "speedInMetersPerSecond"

}

struct PaceKeys {
    let metersPerHour = "metersPerHour"
    let timestamp = "timestamp"
}
struct FirebaseDatabase {
    let childKey = "HikeWorkouts"
}
