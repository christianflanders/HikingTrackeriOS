//
//  Hike In Progress Save To Firebase.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

extension HikeInProgress {
    
    private func convertHikeIntoData(hikeWorkoutToSave: HikeInProgress?) -> [String: Any] {
        var newHikeDict = [String: Any]()
        let firebaseDictStructure = FirebaseDict()
        guard let hikeWorkout = hikeWorkoutToSave else { return newHikeDict }
        
        if let startDate = hikeWorkout.startDate {
            let stringStartDate = startDate.displayString
            newHikeDict[firebaseDictStructure.startDateKey] = stringStartDate
        }
        if let endDate = hikeWorkout.endDate {
            let stringEndDate = endDate.displayString
            newHikeDict[firebaseDictStructure.endDateKey] = stringEndDate
        }
        let caloriesBurned = hikeWorkout.caloriesBurned
        newHikeDict[firebaseDictStructure.caloriesBurnedKey]
            = caloriesBurned
        
        let durationInSeconds = hikeWorkout.durationInSeconds
        newHikeDict[firebaseDictStructure.durationInSecondsKey]
            = durationInSeconds
        
        let totalElevationDifferenceInMeters = hikeWorkout.totalElevationDifferenceInMeters
        newHikeDict[firebaseDictStructure.totalElevationInMetersKey] = totalElevationDifferenceInMeters
        
        //Avg Pace In Meters
        
        let minAltitudeInMeters = hikeWorkout.lowestAltitudeInMeters
        newHikeDict[firebaseDictStructure.minAltitudeInMetersKey] = minAltitudeInMeters
        
        let maxAltitudeInMeters = hikeWorkout.highestAltitudeInMeters
        newHikeDict[firebaseDictStructure.maxAltitudeInMetersKey] = maxAltitudeInMeters
        
        let timeDownhillInSeconds = hikeWorkout.timeDownhillInSeconds
        newHikeDict[firebaseDictStructure.timeDownhillInSecondsKey] = timeDownhillInSeconds
        
        let timeUphillInSeconds = hikeWorkout.timeUphillInSeconds
        newHikeDict[firebaseDictStructure.timeUphillInSecondsKey] = timeUphillInSeconds
        
        var locationDict = [[String: Any]]()
        let locationKeys = Location()
        for location in hikeWorkout.storedLocations {
            var newLocation = [String: Any]()
            newLocation[locationKeys.latitudeKey] = location.coordinate.latitude
            newLocation[locationKeys.longitudeKey] = location.coordinate.longitude
            newLocation[locationKeys.altitudeKey] = location.altitude
            newLocation[locationKeys.speedInMetersPerSecondKey] = location.speed
            newLocation[locationKeys.timestampKey] = location.timestamp.displayString
            locationDict.append(newLocation)
        }
        newHikeDict[firebaseDictStructure.storedLocationsKey] = locationDict
        
        
        return newHikeDict
    }
    
    func convertAndUploadHikeToFirebase(name: String?) {
        let convertedDict = convertHikeIntoData(hikeWorkoutToSave: self)
        var nameForHike = name ?? " "
        let databaseRef = Database.database().reference()
//        if name == nil {
//            nameForHike = "Hike on \(newHike.startDate?.displayString)"
//        } else {
//            nameForHike = name!
//        }
        databaseRef.child("HikeWorkouts").childByAutoId().setValue(convertedDict)
    }
}
