//
//  HikeDisplayStrings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/5/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation

class HikeInProgressDisplay {
    //Contains all the strings we need for the hike in progress screen
    // The current hike object creates one for us, which we give to the Hike In Progress stat display view to put on screen
    
    var duration = "-"
    var altitude = "-"
    var distance = "-"
    var caloriesBurned = "-"
    final var pace = "-"
    final var sunsetTime = "-"
}

class HikeFinishedDisplayStrings: HikeInProgressDisplay {
    var elevationGain = "-"
    var avgPace = "-"
    var avgHeartRate = "-"
    var minAlitude = "-"
    var maxAltitude = "-"
    var timeUphill = "-"
    var timeDownill = "-"
    
}



class ConvertHikeToFinishedDisplayStrings: ConvertHikeToDisplayStrings {
    
    let metersUnit = UnitLength.meters
    
    let dateFormatter = DateFormatter()
    
    func getFinishedDisplayStrings(from hike: HikeWorkoutHappening) -> HikeFinishedDisplayStrings {
        var newDisplay = HikeFinishedDisplayStrings()
        setFormatterStyle()
        let durationFormatted = getDurationDisplayString(from: hike)
        newDisplay.duration = durationFormatted
        
        let altitudeString = getAltitudeDisplayString(from: hike)
        newDisplay.altitude = altitudeString
        
        let distanceString = getDistanceDisplayString(from: hike)
        newDisplay.distance = distanceString
        
        let totalCaloriesBurnedString = getCaloriesDisplayString(from: hike)
        newDisplay.caloriesBurned = totalCaloriesBurnedString
        
        let totalElevationString = calculateTotalElevationChange(from: hike)
        newDisplay.elevationGain = totalElevationString
        
        let lowestAltitudeString = getLowestAltitudeDisplayString(from: hike)
        newDisplay.minAlitude = lowestAltitudeString
        
        let highestAltitudeString = getHighestAltitudeDisplayString(from: hike)
        newDisplay.maxAltitude = highestAltitudeString
        
        let timeTraveledUphillString = getTimeUphillDisplayString(from: hike)
        newDisplay.timeUphill = timeTraveledUphillString
        
        let timeTravledDownhillString = getTimeDownhillDisplayString(from: hike)
        newDisplay.timeDownill = timeTravledDownhillString
        
        return newDisplay
    }
    
    func getLowestAltitudeDisplayString(from hike: HikeWorkoutHappening) -> String {
        let lowestAltitudeInMeters = Measurement(value: hike.lowestAltitudeInMeters, unit: metersUnit)
        let lowestAltitudeString = formatter.string(from: lowestAltitudeInMeters)
        return lowestAltitudeString
    }
    
    func getHighestAltitudeDisplayString(from hike: HikeWorkoutHappening) -> String {
        let highestAltitudeInMeters = Measurement(value: hike.highestAltitudeInMeters, unit: metersUnit)
        let highestAltitudeString = formatter.string(from: highestAltitudeInMeters)
        return highestAltitudeString
    }
    
    func calculateTotalElevationChange(from hike: HikeWorkoutHappening) -> String {
            let totalElevationGainInMeters = hike.highestAltitudeInMeters - hike.lowestAltitudeInMeters
            let totalElevationMeasurment = Measurement(value: totalElevationGainInMeters, unit: metersUnit)
            let totalElevationString = formatter.string(from: totalElevationMeasurment)
            return totalElevationString
    }
    
    func getTimeUphillDisplayString(from hike: HikeWorkoutHappening) -> String {
        let timeTravledUphill = hike.timeTraveldUpHill
        let timeTraveledUphillString = timeTravledUphill.getDisplayString
        return timeTraveledUphillString
    }
    
    func getTimeDownhillDisplayString(from hike: HikeWorkoutHappening) -> String {
        let timeTravledDownhill = hike.timeTraveledDownHill
        let timeTraveledDownhillString = timeTravledDownhill.getDisplayString
        return timeTraveledDownhillString
    }
    

}


