//
//  Hike Display Strings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


import Foundation


class HikeDisplayStrings {
    
    func getInProgressDisplayStrings(hike: HikeInformation) -> HikeInProgressDisplay {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        let newDisplay = HikeInProgressDisplay()
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
        // TODO: Calculate solar time here, instead of inside the hike
        //        if let sunsetTime = self.sunsetTime {
        //            newDisplay.sunsetTime = sunsetTime
        //        }
        //Calories
        let totalCaloriesBurnedString = getCaloriesDisplayString(from: hike)
        newDisplay.caloriesBurned = totalCaloriesBurnedString
        
        return newDisplay
    }
    
    
    func getFinishedDisplayStrings(from hike: HikeInformation) -> HikeFinishedDisplayStrings {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        
        let newDisplay = HikeFinishedDisplayStrings()
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
    
    
    
    private func getCaloriesDisplayString(from hike: HikeInformation) -> String {
        let totalCaloriesBurned = Int(hike.caloriesBurned)
        let totalCaloriesBurnedString = "\(totalCaloriesBurned) kcl"
        return totalCaloriesBurnedString
    }
    
    private func getPaceDisplayString(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        if let lastLocation = hike.storedLocations.last {
            let speedInMetersPerSecond = lastLocation.speed
            let speedMeasurement = Measurement(value: speedInMetersPerSecond.rounded(), unit: UnitLength.meters)
            let speedMeasurementString = formatter.string(from: speedMeasurement)
            let speedMeasurementWithIdentifier = "\(speedMeasurementString)/hr"
            return speedMeasurementWithIdentifier
        } else {
            return "Error"
        }
    }
    
    private func getDurationDisplayString(from hike: HikeInformation) -> String {
        let duration = hike.durationInSeconds
        let durationFormatted = DateHelper().convertDurationToStringDate(duration)
        return durationFormatted
    }
    
    private func getAltitudeDisplayString(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        let altitudeInMeters = Measurement(value: hike.currentAltitudeInMeters.rounded(), unit: UnitLength.meters)
        let altitudeString = formatter.string(from: altitudeInMeters)
        return altitudeString
    }
    
    private func getDistanceDisplayString(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        let distanceInMeters = Measurement(value: hike.totalDistanceInMeters.rounded(), unit: UnitLength.meters)
        let distanceString = formatter.string(from: distanceInMeters)
        return distanceString
    }
    private func getLowestAltitudeDisplayString(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        
        let lowestAltitudeInMeters = Measurement(value: hike.lowestAltitudeInMeters, unit: UnitLength.meters)
        let lowestAltitudeString = formatter.string(from: lowestAltitudeInMeters)
        return lowestAltitudeString
    }
    
    private func getHighestAltitudeDisplayString(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        
        let highestAltitudeInMeters = Measurement(value: hike.highestAltitudeInMeters, unit: UnitLength.meters)
        let highestAltitudeString = formatter.string(from: highestAltitudeInMeters)
        return highestAltitudeString
    }
    
    private func calculateTotalElevationChange(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        
        let totalElevationGainInMeters = hike.highestAltitudeInMeters - hike.lowestAltitudeInMeters
        let totalElevationMeasurment = Measurement(value: totalElevationGainInMeters, unit: UnitLength.meters)
        let totalElevationString = formatter.string(from: totalElevationMeasurment)
        return totalElevationString
    }
    
    private func getTimeUphillDisplayString(from hike: HikeInformation) -> String {
        let timeTravledUphill = hike.timeUphillInSeconds
        let timeTraveledUphillString = timeTravledUphill.getDisplayString
        return timeTraveledUphillString
    }
    
    private func getTimeDownhillDisplayString(from hike: HikeInformation) -> String {
        let timeTravledDownhill = hike.timeDownhillInSeconds
        let timeTraveledDownhillString = timeTravledDownhill.getDisplayString
        return timeTraveledDownhillString
    }
}
