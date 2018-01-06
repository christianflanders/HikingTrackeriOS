//
//  SaveHikeToFirebase.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/4/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import Firebase

struct SaveHikeToFirebase {

    private func convertHikeIntoData(hikeWorkoutToSave: HikeWorkoutHappening?) -> [String: Any] {
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
        let caloriesBurned = hikeWorkout.totalCaloriesBurned
        newHikeDict[firebaseDictStructure.caloriesBurnedKey]
            = caloriesBurned

        let durationInSeconds = hikeWorkout.totalTime
        newHikeDict[firebaseDictStructure.durationInSecondsKey]
        = durationInSeconds

        let totalElevationDifferenceInMeters = hikeWorkout.totalElevationDifferenceInMeters
        newHikeDict[firebaseDictStructure.totalElevationInMetersKey] = totalElevationDifferenceInMeters
        
        //Avg Pace In Meters
        
        let minAltitudeInMeters = hikeWorkout.lowestAltitudeInMeters
        newHikeDict[firebaseDictStructure.minAltitudeInMetersKey] = minAltitudeInMeters
        
        let maxAltitudeInMeters = hikeWorkout.highestAltitudeInMeters
        newHikeDict[firebaseDictStructure.maxAltitudeInMetersKey] = maxAltitudeInMeters

        let timeDownhillInSeconds = hikeWorkout.timeTraveledDownHill
        newHikeDict[firebaseDictStructure.timeDownhillInSecondsKey] = timeDownhillInSeconds
        
        let timeUphillInSeconds = hikeWorkout.timeTraveldUpHill
        newHikeDict[firebaseDictStructure.timeUphillInSecondsKey] = timeUphillInSeconds
        
        var locationDict = [[String: Any]]()
        let locationKeys = Location()
        for location in hikeWorkout.storedLocations {
            var newLocation = [String:Any]()
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
    
    func convertAndUploadHikeToFirebase(_ newHike: HikeWorkoutHappening, name: String?) {
        let convertedDict = convertHikeIntoData(hikeWorkoutToSave: newHike)
        var nameForHike = ""
        let databaseRef = Database.database().reference()
        if name == nil {
            nameForHike = "Hike on \(newHike.startDate?.displayString)"
        } else {
            nameForHike = name!
        }
        databaseRef.child("HikeWorkouts").child(nameForHike).setValue(convertedDict)
    }
    

}

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



