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
    
    
    // Duration
    var startDate: Date?
    var endDate: Date?
    
    //Pause state is set by the view controller, and when it is set, sends an extra location object so the time calculation is accurate
    var paused = false
    var pausedTime = 0.0
    
    
    //These are set in checkElevationDirectionAndSetUpOrDownDuration. They are only added to if the workout is not paused
    //Adding these two values together should match the total time figure. Should probably test for that.
    var timeTraveldUpHill = 0.0
    var timeTraveledDownHill = 0.0
    
    
    //Total time is calculated during the workout by taking the start time and figuring out the interval since then, subtracting paused seconds
    var totalTime: Double {
        get {
            if endDate == nil {
                guard let startTime = startDate else { return 0.0 }
                let currentTime = Date()
                let totalDuration = currentTime.timeIntervalSince(startTime)
                let durationMinusPausedTime = totalDuration - pausedTime
                return durationMinusPausedTime
            } else {
                guard let startTime = startDate else { return 0.0 }
                guard let endDate = endDate else { return 0.0 }
                let totalDuration = endDate.timeIntervalSince(startTime)
                let durationMinusPausedTime = totalDuration - pausedTime
                return durationMinusPausedTime
            }

        }
    }
    
    
    // Distance
    var totalDistanceInMeters = 0.0
    
    // Altitude
    var currentAltitudeInMeters = 0.0
    
    var highestAltitudeInMeters: Double {
        get {
            if storedLocations.count != 0 {
                let highestAltitude = storedLocations.reduce(0.0) { max($0, $1.altitude)}
                return highestAltitude
                } else {
                    return 0.0
                }
            }
        }
    
    var lowestAltitudeInMeters: Double {
        get {
            if storedLocations.count != 0 {
                guard let firstLocationAltitude = self.storedLocations.first?.altitude else {return 0.0}
                let highestAltitude = storedLocations.reduce(firstLocationAltitude) { min($0, $1.altitude)}
                return highestAltitude
            } else {
                return 0.0
            }
        }
    }
    
    var totalElevationDifferenceInMeters: Double {
        get {
            return self.highestAltitudeInMeters - self.lowestAltitudeInMeters
        }
    }
    
    // Calories
    
    // Will update in future with better calorie calculation algorithm
    private let user = StoredUser()
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
    
    // Locations
    var storedLocations = [CLLocation]()
    
    //This is where most of the functionality happens. The view controller gives us a location object, we figure out if we're going up or downhill currently, if we're paused or not, and sets distance and duration information
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
    
    
    //Used for drawing the line on the map
    var coordinates: [CLLocationCoordinate2D] {
        get {
            return storedLocations.map { return $0.coordinate }
            
        }
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
    
    // Display
    
    
    var sunsetTime: String? {
        get {
            guard let currentLocation = self.storedLocations.first else { return " " }
            guard let startDate = startDate else {return " "}
            let solar = Solar(for: startDate, coordinate: currentLocation.coordinate)
            guard let sunset = solar?.sunset else { return "" }
            let string = sunset.displayTimeOnly
            return string
        }
    }
    
    // Called to figure out the information we need for the stats display, returns a display object to display on screen
 
    
    
}




