//
//  HikeInProgressDisplay.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/4/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


class ConvertHikeToDisplayStrings {
    
    let formatter = MeasurementFormatter()
    
    func setFormatterStyle(){
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
    }
    
    final func getDisplayStrings(from hike: HikeWorkoutHappening) -> HikeInProgressDisplay {
        var newDisplay = HikeInProgressDisplay()
        setFormatterStyle()
        let durationFormatted = getDurationDisplayString(from: hike)
        newDisplay.duration = durationFormatted
        
        //Duration
        let altitudeString = getAltitudeDisplayString(from: hike)
        newDisplay.altitude = altitudeString
        
        //Distance
        let distanceString = getDistanceDisplayString(from: hike)
        newDisplay.distance = distanceString
        
        //Pace
        let speedString = getPaceDisplayString(from: hike)
        
        newDisplay.pace = speedString
        
        //Sunset
        if let sunsetTime = hike.sunsetTime {
            newDisplay.sunsetTime = sunsetTime
        }
        //Calories
        let totalCaloriesBurnedString = getCaloriesDisplayString(from: hike)
        newDisplay.caloriesBurned = totalCaloriesBurnedString
        
        return newDisplay
    }
    
    func getCaloriesDisplayString(from hike: HikeWorkoutHappening) -> String {
        let totalCaloriesBurnedString = hike.totalCaloriesBurned.getDisplayString
        return totalCaloriesBurnedString
    }
    
    func getPaceDisplayString(from hike: HikeWorkoutHappening) -> String {
        if let lastLocation = hike.storedLocations.last {
            let speedInMetersPerSecond = lastLocation.speed
            let speedMeasurement = Measurement(value: speedInMetersPerSecond, unit: UnitLength.meters)
            let speedMeasurementString = formatter.string(from: speedMeasurement)
            let speedMeasurementWithIdentifier = "\(speedMeasurementString)/hr"
            return speedMeasurementWithIdentifier
        } else {
            return "Error"
        }
    }
    
    func getDurationDisplayString(from hike: HikeWorkoutHappening) -> String {
        let duration = hike.totalTime
        let durationFormatted = DateHelper().convertDurationToStringDate(duration)
        return durationFormatted
    }
    
    func getAltitudeDisplayString(from hike: HikeWorkoutHappening) -> String {
        let altitudeInMeters = Measurement(value: hike.currentAltitudeInMeters, unit: UnitLength.meters)
        let altitudeString = formatter.string(from: altitudeInMeters)
        return altitudeString
    }
    
    func getDistanceDisplayString(from hike: HikeWorkoutHappening) -> String {
        let distanceInMeters = Measurement(value: hike.totalDistanceInMeters, unit: UnitLength.meters)
        let distanceString = formatter.string(from: distanceInMeters)
        return distanceString
    }
}

