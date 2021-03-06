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
        if !paused {
            setNewAltitude(newLocation)
            locationComparisons(newLocation)
            addToStoredLocations(newLocation)
        }
    }

    private func locationComparisons(_ newLocation: CLLocation) {
        guard let lastLocation = storedLocations.last else { return }
        checkElevationDirectionAndSetUpOrDownDuration(lastLocation: lastLocation, newLocation: newLocation)
        let newPace = calculatePaceBetweenTwoPoints(pointOne: lastLocation, pointTwo: newLocation)
        storedPaces.append(newPace)
        addToDistance(newLocation: newLocation, lastLocation: lastLocation)
    }

    private func addToDistance(newLocation: CLLocation, lastLocation:CLLocation) {
        totalDistanceInMeters += lastLocation.distance(from: newLocation)
    }

    private func setNewAltitude(_ location: CLLocation) {
        currentAltitudeInMeters = location.altitude
    }

    private func addToStoredLocations(_ location: CLLocation) {
        storedLocations.append(location)
    }

    private func checkElevationDirectionAndSetUpOrDownDuration(lastLocation: CLLocation, newLocation: CLLocation) {
        if !paused {
            let timeDifference = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
            if lastLocation.altitude < newLocation.altitude {
                timeUphillInSeconds += timeDifference
            } else if lastLocation.altitude > newLocation.altitude || lastLocation.altitude == newLocation.altitude {
                timeDownhillInSeconds += timeDifference
            }
        }
    }

    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
    }


    // MARK: Pace

    //MIn/ mile
    //Min/ Meter

    var storedPaces = [Pace]()
    var currentPaceInMetersPerHour = 0.0

    func calculatePaceBetweenTwoPoints(pointOne: CLLocation, pointTwo: CLLocation) -> Pace{
        let pointOneDate = pointOne.timestamp
        let pointTwoDate = pointTwo.timestamp
        let timeBetweenInSeconds = pointTwoDate.timeIntervalSince(pointOneDate)

        let distanceBetweenPointsInMeters = pointTwo.distance(from: pointOne)
        let currentPaceInMinutesPerMeter = calulateMetersPerHourFrom(seconds: timeBetweenInSeconds, distanceInMeters: distanceBetweenPointsInMeters)
        let newPace = Pace(minutesPerMeter: currentPaceInMinutesPerMeter, timeStamp: pointTwoDate)
        return newPace
    }

    func calulateMetersPerHourFrom(seconds: Double, distanceInMeters: Double) -> Double{

        let secondsPerMeter = seconds / distanceInMeters
        let minutesperMeter = secondsPerMeter / 60.0

        return minutesperMeter
    }

    // MARK: Altitude Information

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
    
    func pauseHike() {
        let timePaused = Date()
        pausedNotificationTime = timePaused
        self.paused = true
    }
    
    func resumeHike() {
        let resumedTime = Date()
        self.paused = false
        guard let previousPausedNotification = pausedNotificationTime else { return }
        let pausedDuration = resumedTime.timeIntervalSince(previousPausedNotification)
        totalPausedTime += pausedDuration
        print("That pause was \(pausedDuration)")
        print("Total time paused is \(totalPausedTime)")
    }

    func endHike() {
//        resumeHike()
        var endTime = Date()
        if let pausedNotification = pausedNotificationTime {
            totalPausedTime += endTime.timeIntervalSince(pausedNotification)
        }
        self.endDate = endTime
        calculateUphillVSDownhill()
    }

    func converToHistory() -> HikeHistory {
        var hikeHistoryObject = HikeHistory(fromInProgress: self)
        return hikeHistoryObject
    }

    func calculateUphillVSDownhill() {
        if (timeUphillInSeconds + timeDownhillInSeconds) != durationInSeconds {
            let difference = durationInSeconds - (timeUphillInSeconds + timeDownhillInSeconds)
            timeDownhillInSeconds += difference
        }
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
