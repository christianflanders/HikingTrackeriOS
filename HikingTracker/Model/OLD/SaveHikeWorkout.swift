//
//  SaveHikeWorkout.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/1/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreData
import HealthKit
import CoreLocation

struct SaveHike {
    
    func saveToCoreData(hike: HikeWorkoutInProgress) {
        guard let hikeName = hike.hikeName else { return }
        let dataStore = PersistanceService.store
        dataStore.storeHikeWorkout(hikeWorkout: hike, name: hikeName)
    }
    
    func saveToHealthKit(hike: HikeWorkoutInProgress) {
        guard let hikeName = hike.hikeName else { return }
        let healthKit = HealthKitStore()
        healthKit.storeHikeToHealthKit(hike, name: hikeName)
    }
    
    
}


//class HikeHistoryRecord {
//    
//    // Information
//    var name: String?
//    var notes: String?
//    
//    // Duration
//    let startDate: Date?
//    let endDate: Date?
//        let pausedTime: Double?
//    let timeTraveledUphill: Double?
//    let totalTime: Double?
//    
//    // Distance
//    
//    let totalDistanceInMeters: Meters?
//    let distanceUphillInMeters: Meters?
//        let distanceDownhillInMeters: Meters?
//    
//        // Elevation
//    
//    let lowestAltitudeInMeters: Meters?
//        let highestAltitudeInMeters: Meters?
//    
//            // Calories
//    
//    let totalCaloriesBurned: Calorie?
//    
//    // Pace
//    
//    
//    
//    // Heart Rate (if avaliable)
//    
//    // Locations
//    let storedLocations = [CLLocation]()
//        let coordinates = [CLLocationCoordinate2D]()
//    
//
//    init(liveHikeWorkout: HikeWorkoutHappening) {
//        <#statements#>
//    }
//}
//
//
//struct ConvertHikeToSaved {
//    
//    public var hikeWorkoutToBeConverted = HikeWorkoutHappening()
//    
//    
//    
//}

