//
//  Hike Display Strings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


extension HikeInProgress {
    
    
    func getInProgressDisplayStrings() -> HikeInProgressDisplay {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        let newDisplay = HikeInProgressDisplay()
        let durationFormatted = getDurationDisplayString(from: self)
        newDisplay.duration = durationFormatted
        
        //Duration
        let altitudeString = getAltitudeDisplayString(from: self)
        newDisplay.altitude = altitudeString
        
        //Distance
        let distanceString = getDistanceDisplayString(from: self)
        newDisplay.distance = distanceString
        
        //Pace
        let speedString = getPaceDisplayString(from: self)
        
        newDisplay.pace = speedString
        
        //Sunset
        if let sunsetTime = self.sunsetTime {
            newDisplay.sunsetTime = sunsetTime
        }
        //Calories
        let totalCaloriesBurnedString = getCaloriesDisplayString(from: self)
        newDisplay.caloriesBurned = totalCaloriesBurnedString
        
        return newDisplay
    }
    
    private func getCaloriesDisplayString(from hike: HikeInProgress) -> String {
        let totalCaloriesBurned = Int(hike.caloriesBurned)
        let totalCaloriesBurnedString = "\(totalCaloriesBurned) kcl"
        return totalCaloriesBurnedString
    }
    
    private func getPaceDisplayString(from hike: HikeInProgress) -> String {
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
    
    private func getDurationDisplayString(from hike: HikeInProgress) -> String {
        let duration = hike.durationInSeconds
        let durationFormatted = DateHelper().convertDurationToStringDate(duration)
        return durationFormatted
    }
    
    private func getAltitudeDisplayString(from hike: HikeInProgress) -> String {
        let formatter = MeasurementFormatter()
        let altitudeInMeters = Measurement(value: hike.currentAltitudeInMeters.rounded(), unit: UnitLength.meters)
        let altitudeString = formatter.string(from: altitudeInMeters)
        return altitudeString
    }
    
    private func getDistanceDisplayString(from hike: HikeInProgress) -> String {
        let formatter = MeasurementFormatter()
        let distanceInMeters = Measurement(value: hike.totalDistanceInMeters.rounded(), unit: UnitLength.meters)
        let distanceString = formatter.string(from: distanceInMeters)
        return distanceString
    }
}

