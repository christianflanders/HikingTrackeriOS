//
//  Hike Information Protocol.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation

protocol HikeInformation {
    
    //This is the main information we need for the hike.
    var storedLocations: [CLLocation] {get}
    var startDate: Date? {get}
    var endDate: Date? {get}
    var caloriesBurned: Double {get}
    var durationInSeconds: Double {get}
    var totalElevationDifferenceInMeters: Double {get}
    var lowestAltitudeInMeters: Double {get}
    var highestAltitudeInMeters: Double {get}
    var timeDownhillInSeconds: Double {get}
    var timeUphillInSeconds: Double {get}
    var totalDistanceInMeters: Double {get}
    var currentAltitudeInMeters: Double {get}
    var storedPaces: [Pace] {get}
}
