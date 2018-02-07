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
        
        //Altitude
        let currentAltitudeInMeters = hike.currentAltitudeInMeters
        let altitudeString = currentAltitudeInMeters.getDisplayString
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
        newDisplay.avgPace = getAveragePaceDisplayString(from: hike)
        return newDisplay
    }
    
    
    
    private func getCaloriesDisplayString(from hike: HikeInformation) -> String {
        let totalCaloriesBurned = Int(hike.caloriesBurned)
        let totalCaloriesBurnedString = "\(totalCaloriesBurned) kcl"
        return totalCaloriesBurnedString
    }

    private func getAveragePaceDisplayString(from hike: HikeInformation) -> String {
        let formatter = MeasurementFormatter()
        if !hike.storedPaces.isEmpty {
            let storedPaces = hike.storedPaces
            let totalPacesReduced = storedPaces.reduce(0.0,{ $0 + $1.minutesPerMeter} )
            let averagePaceInMetersPerHour = totalPacesReduced / Double(storedPaces.count)
            let averagePaceMeasurment = Measurement(value: averagePaceInMetersPerHour, unit: UnitLength.meters)
            let averagePaceMeasurementString = formatter.string(from: averagePaceMeasurment)
//            var unit = ""
//            if StoredUser().userDisplayUnits == .freedomUnits {
//                unit = "miles"
//            } else {
//                unit = "km"
//            }
            let returnString = "\(averagePaceMeasurementString)/hr"
            return returnString
        } else {
            return "_"
        }
    }
    
    private func getPaceDisplayString(from hike: HikeInformation) -> String {
        if !hike.storedPaces.isEmpty {
            let lastPace = hike.storedPaces.last
            let speedInMinutesPerMeter = lastPace?.minutesPerMeter
            let speedInMinutesPerKM = speedInMinutesPerMeter! * 1000.0
            if StoredUser().userDisplayUnits == .metric {
                let speedString = String(format: "%.2f", speedInMinutesPerKM)
                let returnString = "\(speedString) min/km"
                return returnString
            } else {
                let conv = UnitConversions()
                let minutesPerMile = conv.convertKiloMetersToMiles(speedInMinutesPerKM)
                let minutesPerMileString = String(format: "%.2f", minutesPerMile)
                let returnString = "\(minutesPerMileString) min/mile"
                return returnString
            }

        } else {
            return "_"
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
        let hikeLowestAltitudeInMeters = hike.lowestAltitudeInMeters
        let lowestAltitudeString = hikeLowestAltitudeInMeters.getMetersOrFeetOnly
        return lowestAltitudeString
    }
    
    private func getHighestAltitudeDisplayString(from hike: HikeInformation) -> String {
        let hikeHighestAltitudeInMeters = hike.highestAltitudeInMeters
        let highestAltitudeString = hikeHighestAltitudeInMeters.getMetersOrFeetOnly
        return highestAltitudeString
    }
    
    private func calculateTotalElevationChange(from hike: HikeInformation) -> String {
        let totalElevationGainInMeters = hike.highestAltitudeInMeters - hike.lowestAltitudeInMeters
        let totalElevationString = totalElevationGainInMeters.getMetersOrFeetOnly
        return totalElevationString
    }
    
    private func getTimeUphillDisplayString(from hike: HikeInformation) -> String {
        let dateHelper = DateHelper()
        let timeTravledUphill = hike.timeUphillInSeconds
        let timeTraveledUphillString = dateHelper.convertDurationToStringDate(timeTravledUphill)
        return timeTraveledUphillString
    }
    
    private func getTimeDownhillDisplayString(from hike: HikeInformation) -> String {
        let dateHelper = DateHelper()
        let timeTravledDownhill = hike.timeDownhillInSeconds
        let timeTraveledDownhillString = dateHelper.convertDurationToStringDate(timeTravledDownhill)
        return timeTraveledDownhillString
    }
}

