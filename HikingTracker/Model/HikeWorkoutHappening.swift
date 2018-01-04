//
//  HikeWorkoutHappening.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/3/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import CoreData
import HealthKit


class HikeWorkoutHappening {
    
    let formatter = Formatter()
    
    var totalDistanceInMeters = 0.0
    
    var paused = false
    var timeTraveldUpHill = 0.0
    var timeTraveledDownHill = 0.0
    
    var pausedTime = 0.0
    
    var totalTime: Double {
        get {
            guard let startTime = startDate else { return 0.0 }
            let currentTime = Date()
            let totalDuration = currentTime.timeIntervalSince(startTime)
            let durationMinusPausedTime = totalDuration - pausedTime
            return durationMinusPausedTime
        }
    }
    
    var startDate: Date?
    var endDate: Date?
    
    var currentAltitudeInMeters = 0.0
    
    let user = StoredUser()
    
    var storedLocations = [CLLocation]()
    
    func addNewLocation(_ newLocation: CLLocation) {
        currentAltitudeInMeters = newLocation.altitude
        if storedLocations.isEmpty {
            storedLocations.append(newLocation)
            return
        }
        guard let lastLocation = storedLocations.last else {return}
        checkElevationDirectionAndSetUpOrDownDuration(lastLocation: lastLocation, newLocation: newLocation)
        checkIfPausedAndSetCorrectDuration(lastLocation: lastLocation, newLocation: newLocation)
        totalDistanceInMeters += lastLocation.distance(from: newLocation)
        storedLocations.append(newLocation)
        
    }
    
    private func checkElevationDirectionAndSetUpOrDownDuration(lastLocation: CLLocation, newLocation:CLLocation) {
        if !paused {
            let timeDifference = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
            if lastLocation.altitude < newLocation.altitude {
                timeTraveldUpHill += timeDifference
            } else if lastLocation.altitude > newLocation.altitude || lastLocation.altitude == newLocation.altitude {
                timeTraveledDownHill += timeDifference
            }
        }
    }
    
    private func checkIfPausedAndSetCorrectDuration(lastLocation: CLLocation, newLocation:CLLocation) {
        let timeDifference = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
        if paused {
            pausedTime += timeDifference
        }
    }
    
    private let hikeUphillMETValue = 6.00
    private let hikeDownhillMETValue = 2.8
    
    var totalCaloriesBurned: Calorie {
        get {
            var totalCaloriesBurned: Double = 0.0
            guard let userWeight = user.weightInKilos else {return 0}
            
            let caloriesBurnedPerHourUphill = userWeight * hikeUphillMETValue
            let percentageOfHourUphill = Double(timeTraveldUpHill) * 0.0002
            totalCaloriesBurned += caloriesBurnedPerHourUphill * percentageOfHourUphill
            
            let caloriesBurnedPerHourDownhill = userWeight * hikeDownhillMETValue
            let percentageOfHourDownhill = Double(timeTraveledDownHill) * 0.0002
            totalCaloriesBurned += caloriesBurnedPerHourDownhill * percentageOfHourDownhill
            return totalCaloriesBurned
        }
    }
    
    
    var coordinates: [CLLocationCoordinate2D] {
        get {
            return storedLocations.map { return $0.coordinate }
            
        }
    }
    
    private var sunsetTime: String? {
        get {
            guard let currentLocation = self.storedLocations.first else { return " " }
            guard let startDate = startDate else {return " "}
            let solar = Solar(for: startDate, coordinate: currentLocation.coordinate)
            guard let sunset = solar?.sunset else { return "" }
            let string = sunset.displayTimeOnly
            return string
        }
    }
    
    func getDisplayStrings() -> HikeInProgressDisplay {
        var newDisplay = HikeInProgressDisplay()
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale


        //Duration
        let duration = totalTime
        let durationFormatted = DateHelper().convertDurationToStringDate(duration)
        newDisplay.duration = durationFormatted
        //Altitude
        let altitudeInMeters = Measurement(value: currentAltitudeInMeters, unit: UnitLength.meters)
        let altitudeString = formatter.string(from: altitudeInMeters)
        newDisplay.altitude = altitudeString
        
        //Distance
        let distanceInMeters = Measurement(value: totalDistanceInMeters, unit: UnitLength.meters)
        let distanceString = formatter.string(from: distanceInMeters)
        newDisplay.distance = distanceString
        
        //Pace
//        if let lastLocation = storedLocations.last {
//            let speedInMetersPerSecond = lastLocation.speed
//            let speedMeasurement = Measurement(value: speedInMetersPerSecond, unit: UnitLength.meters)
//            let speedMeasurementString = formatter.string(from: speedMeasurement)
//            let speedMeasurementWithIdentifier = "\(speedMeasurementString)/hr"
//            newDisplay.pace = speedMeasurementWithIdentifier
//        }
        //Sunset
        if let sunsetTime = sunsetTime {
            newDisplay.sunsetTime = sunsetTime
        }
        //Calories
        let totalCaloriesBurnedString = totalCaloriesBurned.getDisplayString
        newDisplay.caloriesBurned = totalCaloriesBurnedString
        
        return newDisplay
    }

}

struct HikeInProgressDisplay {
    var duration = "-"
    var altitude = "-"
    var distance = "-"
    var caloriesBurned = "-"
    var pace = "-"
    var sunsetTime = "-"
    
    
}
