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


class ConvertHikeToDisplayStrings {
    
    fileprivate let formatter = MeasurementFormatter()
    
    fileprivate func setFormatterStyle(){
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
    }
    
    final func getDisplayStrings(from hike: HikeWorkoutHappening) -> HikeInProgressDisplay {
        let newDisplay = HikeInProgressDisplay()
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
    
    fileprivate func getCaloriesDisplayString(from hike: HikeWorkoutHappening) -> String {
        let totalCaloriesBurned = hike.totalCaloriesBurned
        let totalCaloriesBurnedString = "\(totalCaloriesBurned) kcl"
        return totalCaloriesBurnedString
    }
    
    fileprivate func getPaceDisplayString(from hike: HikeWorkoutHappening) -> String {
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
    
    fileprivate func getDurationDisplayString(from hike: HikeWorkoutHappening) -> String {
        let duration = hike.totalTime
        let durationFormatted = DateHelper().convertDurationToStringDate(duration)
        return durationFormatted
    }
    
    fileprivate func getAltitudeDisplayString(from hike: HikeWorkoutHappening) -> String {
        let altitudeInMeters = Measurement(value: hike.currentAltitudeInMeters, unit: UnitLength.meters)
        let altitudeString = formatter.string(from: altitudeInMeters)
        return altitudeString
    }
    
    fileprivate func getDistanceDisplayString(from hike: HikeWorkoutHappening) -> String {
        let distanceInMeters = Measurement(value: hike.totalDistanceInMeters, unit: UnitLength.meters)
        let distanceString = formatter.string(from: distanceInMeters)
        return distanceString
    }
}


class ConvertHikeToFinishedDisplayStrings: ConvertHikeToDisplayStrings {
    
    private let metersUnit = UnitLength.meters
    
    private let dateFormatter = DateFormatter()
    
    func getFinishedDisplayStrings(from hike: HikeWorkoutHappening) -> HikeFinishedDisplayStrings {
        let newDisplay = HikeFinishedDisplayStrings()
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
        
        
        // TODO: Temporary until these are added
        newDisplay.avgHeartRate = "-"
        newDisplay.avgPace = "-"
        return newDisplay
    }
    
    private func getLowestAltitudeDisplayString(from hike: HikeWorkoutHappening) -> String {
        let lowestAltitudeInMeters = Measurement(value: hike.lowestAltitudeInMeters, unit: metersUnit)
        let lowestAltitudeString = formatter.string(from: lowestAltitudeInMeters)
        return lowestAltitudeString
    }
    
    private func getHighestAltitudeDisplayString(from hike: HikeWorkoutHappening) -> String {
        let highestAltitudeInMeters = Measurement(value: hike.highestAltitudeInMeters, unit: metersUnit)
        let highestAltitudeString = formatter.string(from: highestAltitudeInMeters)
        return highestAltitudeString
    }
    
    private func calculateTotalElevationChange(from hike: HikeWorkoutHappening) -> String {
            let totalElevationGainInMeters = hike.highestAltitudeInMeters - hike.lowestAltitudeInMeters
            let totalElevationMeasurment = Measurement(value: totalElevationGainInMeters, unit: metersUnit)
            let totalElevationString = formatter.string(from: totalElevationMeasurment)
            return totalElevationString
    }
    
    private func getTimeUphillDisplayString(from hike: HikeWorkoutHappening) -> String {
        let timeTravledUphill = hike.timeTraveldUpHill
        let timeTraveledUphillString = timeTravledUphill.getDisplayString
        return timeTraveledUphillString
    }
    
    private func getTimeDownhillDisplayString(from hike: HikeWorkoutHappening) -> String {
        let timeTravledDownhill = hike.timeTraveledDownHill
        let timeTraveledDownhillString = timeTravledDownhill.getDisplayString
        return timeTraveledDownhillString
    }

}


