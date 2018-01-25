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


class HikeInProgress: HikeInformation {
    
    var hikeName = ""

    // MARK: Location information
    
    //All the locations we have added to the hike
    var storedLocations = [CLLocation]()
    
    //Call this from the parent view controller when corelocation gets a new location
    func addNewLocation(_ newLocation: CLLocation) {
        currentAltitudeInMeters = newLocation.altitude
        if storedLocations.isEmpty {
            storedLocations.append(newLocation)
            return
        }
        guard let lastLocation = storedLocations.last else {return}
        checkElevationDirectionAndSetUpOrDownDuration(lastLocation: lastLocation, newLocation: newLocation)
        let newPace = calculatePaceBetweenTwoPoints(pointOne: lastLocation, pointTwo: newLocation)
        storedPaces.append(newPace)
        totalDistanceInMeters += lastLocation.distance(from: newLocation)
        storedLocations.append(newLocation)
    }
    
    private func checkElevationDirectionAndSetUpOrDownDuration(lastLocation: CLLocation, newLocation: CLLocation) {
        if !paused {
            let timeDifference = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
            if lastLocation.altitude < newLocation.altitude {
                timeUphillInSeconds += timeDifference
                currentAltitudeDirection = CurrentAltitudeDirection.uphill
            } else if lastLocation.altitude > newLocation.altitude || lastLocation.altitude == newLocation.altitude {
                timeDownhillInSeconds += timeDifference
                currentAltitudeDirection = CurrentAltitudeDirection.downhill
            }
        }
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
    }


    // MARK: Pace

    var storedPaces = [Pace]()
    var currentPaceInMetersPerHour = 0.0

    func calculatePaceBetweenTwoPoints(pointOne: CLLocation, pointTwo: CLLocation) -> Pace{
        let pointOneDate = pointOne.timestamp
        let pointTwoDate = pointTwo.timestamp
        let timeBetweenInSeconds = pointTwoDate.timeIntervalSince(pointOneDate)

        let distanceBetweenPointsInMeters = pointTwo.distance(from: pointOne)

        let currentPaceInMetersPerHour = calulateMetersPerHourFrom(seconds: timeBetweenInSeconds, distanceInMeters: distanceBetweenPointsInMeters)
        let newPace = Pace(metersTraveledPerHour: currentPaceInMetersPerHour, timeStamp: pointTwoDate)
        return newPace

        
    }

    func calulateMetersPerHourFrom(seconds: Double, distanceInMeters: Double) -> Double{
        let secondsInOneHour = 3600.0
        let mySecondsConvertedToHour = seconds / secondsInOneHour
//        let oneHour = mySecondsConvertedToHour / mySecondsConvertedToHour
        let metersTraveledInOneHour = distanceInMeters / mySecondsConvertedToHour
        return metersTraveledInOneHour
    }
    // MARK: Altitude Information
    private var currentAltitudeDirection: CurrentAltitudeDirection?
    
    var currentAltitudeInMeters = 0.0
    
    var totalElevationDifferenceInMeters: Double {
        return self.highestAltitudeInMeters - self.lowestAltitudeInMeters
    }
    
    var highestAltitudeInMeters: Double {
        if storedLocations.count != 0 {
            let highestAltitude = storedLocations.reduce(0.0) { max($0, $1.altitude)}
            return highestAltitude
        } else {
            return 0.0
        }
    }
    
    var lowestAltitudeInMeters: Double {
        if storedLocations.count != 0 {
            guard let firstLocationAltitude = self.storedLocations.first?.altitude else {return 0.0}
            let highestAltitude = storedLocations.reduce(firstLocationAltitude) { min($0, $1.altitude)}
            return highestAltitude
        } else {
            return 0.0
        }
    }
    
    // MARK: Distance Information
    
    var totalDistanceInMeters = 0.0
    
    
    // MARK: Duration Information
    
    var durationInSeconds: Double {
        if endDate == nil {
            guard let startTime = startDate else { return 0.0 }
            let currentTime = Date()
            let totalDuration = currentTime.timeIntervalSince(startTime)
            let durationMinusPausedTime = totalDuration - totalPausedTime
            return durationMinusPausedTime
        } else {
            guard let startTime = startDate else { return 0.0 }
            guard let endDate = endDate else { return 0.0 }
            let totalDuration = endDate.timeIntervalSince(startTime)
            let durationMinusPausedTime = totalDuration - totalPausedTime
            return durationMinusPausedTime
        }
    }
    
    var timeDownhillInSeconds = 0.0
    
    var timeUphillInSeconds = 0.0
    
    var startDate: Date?
    
    var endDate: Date?
    
    // MARK: Add Pause Functionality
    var pausedNotificationTime: Date?
    
    var paused = false
    var totalPausedTime = 0.0
    
    func pauseHike(time: Date) {
        pausedNotificationTime = time
    }
    
    func resumeHike(time: Date) {
        let resumedTime = time
        guard let previousPausedNotification = pausedNotificationTime else { return }
        let pausedDuration = resumedTime.timeIntervalSince(previousPausedNotification)
        totalPausedTime += pausedDuration
        print("That pause was \(pausedDuration)")
        print("Total time paused is \(totalPausedTime)")
    }
    
    // MARK: Calories
    
    private let hikeUphillMETValue = 6.00
    private let hikeDownhillMETValue = 2.8
    
    var caloriesBurned: Double {
        let user = StoredUser()
        var totalCaloriesBurned: Double = 0.0
        guard let userWeight = user.weightInKilos else {return 0}
        
        let caloriesBurnedPerHourUphill = userWeight * hikeUphillMETValue
        let percentageOfHourUphill = timeUphillInSeconds * 0.0002
        totalCaloriesBurned += caloriesBurnedPerHourUphill * percentageOfHourUphill
        
        let caloriesBurnedPerHourDownhill = userWeight * hikeDownhillMETValue
        let percentageOfHourDownhill = timeUphillInSeconds * 0.0002
        totalCaloriesBurned += caloriesBurnedPerHourDownhill * percentageOfHourDownhill
        return totalCaloriesBurned
    }

    // MARK: Sunset
    
    var sunsetTime: String? {
        guard let currentLocation = self.storedLocations.first else { return " " }
        guard let startDate = startDate else {return " "}
        let solar = Solar(for: startDate, coordinate: currentLocation.coordinate)
        guard let sunset = solar?.sunset else { return "" }
        let string = sunset.displayTimeOnly
        return string
    }
}
