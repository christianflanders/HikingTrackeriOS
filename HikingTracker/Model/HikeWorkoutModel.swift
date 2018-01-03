//
//  HikeWorkoutModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import CoreData
import HealthKit


class HikeWorkout {
    
    init() {
    }
    
    deinit {
    }
    
    let user = StoredUser()
    
    var hikeName: String?

    private let dateHelper = DateHelper()
    
    var pausedTime = 0.0
    var paused = false
    //Time Information
//    var seconds = 0
    var startDate: Date?
    var endDate: Date?
    
    var duration: Double = 0
    
    var calculatedDuration: Double {
        get {
            if endDate != nil {
                guard let startDate = startDate else { return 0 }
                guard let endDate = endDate else { return 0 }
                let calculatedDuration = endDate.timeIntervalSince(startDate)
                let calculatedDurationWithoutPausedTime = calculatedDuration - pausedTime
                return calculatedDurationWithoutPausedTime
            } else {
                guard let startDate = startDate else { return 0 }
                let currentTime = Date()
                let timeSinceStartDate = currentTime.timeIntervalSince(startDate)
                let totalSecondsSubtractingPausedSeconds = timeSinceStartDate - pausedTime
                return totalSecondsSubtractingPausedSeconds
            }
        }
    }

     var durationAsString: String {
        get {
            return dateHelper.convertDurationToStringDate(calculatedDuration)
        }
    }
    
    var timeTraveldUpHill = 0.0
    var timeTraveledDownHill = 0.0
    
    var timeTraveledUpHillDisplayString: String {
        get {
            return dateHelper.convertDurationToStringDate(timeTraveldUpHill)
        }
    }
    
    var timeTraveledDownhilllDisplayString: String {
        get {
            return dateHelper.convertDurationToStringDate(timeTraveledDownHill)
        }
    }

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
    
    
    //Elevation & Distance Information
    
    var lowestElevation: Meters {
        get {
            guard var lowestAltitude = storedLocations.first?.altitude else {return 0}
            for location in storedLocations {
                if location.altitude < lowestAltitude {
                    lowestAltitude = location.altitude
                }
            }
            return Meters(lowestAltitude)
        }
    }
    
    
    var highestElevation: Meters {
        get {
            guard var highestAltitude = storedLocations.first?.altitude else {return 0}
            for location in storedLocations {
                if location.altitude > highestAltitude {
                    highestAltitude = location.altitude
                }
            }
            return Meters(highestAltitude)
        }
    }
    
    var totalDistanceTraveled: Meters? {
        get {
            guard let distanceTraveledUphill = distanceTraveledUphill else {return 0}
            guard let distanceTraveledDownhill = distanceTraveledDownhill else {return 0}
            return distanceTraveledUphill + distanceTraveledDownhill
        }
    }
    
    var distanceTraveledDownhill: Meters? {
        get {
            var totalDistanceTraveleDownhill = 0.0
            guard var lastLocation = storedLocations.first else {return 0.0}
            for i in storedLocations {
                if i.altitude < lastLocation.altitude {
                    totalDistanceTraveleDownhill += i.distance(from: lastLocation)
                    
                }
                lastLocation = i
            }
            return totalDistanceTraveleDownhill
        }
    }
    
    var distanceTraveledUphill: Meters? {
        get {
            var totalDistanceTraveleDownhill = 0.0
            guard var lastLocation = storedLocations.first else {return 0.0}
            for i in storedLocations {
                if i.altitude < lastLocation.altitude {
                    totalDistanceTraveleDownhill += i.distance(from: lastLocation)
                    
                }
                lastLocation = i
            }
            return totalDistanceTraveleDownhill
        }
    }
    
    
        //Calorie Information
    
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
    
    //Locations
    
    var storedLocations = [CLLocation]()
    
    var lastLocation: CLLocation? {
        willSet (newLocation) {
            guard let lastLocationSet = lastLocation else {return}
            guard let newLocationToSet = newLocation else {return}
            //Check if we're going up or down hill and add that to our time traveled in either direction
            let lastLocationTime = lastLocationSet.timestamp
            if !paused {
                if lastLocationSet.altitude < newLocationToSet.altitude {
                    timeTraveldUpHill += Double(newLocationToSet.timestamp.timeIntervalSince(lastLocationTime))
                } else if lastLocationSet.altitude > newLocationToSet.altitude {
                    timeTraveledDownHill += Double(newLocationToSet.timestamp.timeIntervalSince(lastLocationTime))
                }
            }
            //Add the previous location to our stored Locations
            storedLocations.append(lastLocationSet)
        }
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
    }
    
    
    //Pace
    
    var storedPaceHistory = [metersPerHour]()
    
    
    


}


struct metersPerHour{
    var metersPerHourValue: Meters
    var timeStamp: Date
    
    var displayString: String {
        get {
            if StoredUser().userDisplayUnits == .freedomUnits {
                let milesPerHour = Int(self.metersPerHourValue.asMiles)
                let mphString = "\(milesPerHour) miles/hr"
                return mphString
            } else {
                let metersPerHourTruncated = Int(self.metersPerHourValue)
                let metersPerHourString = "\(metersPerHourTruncated) mtr/hr"
                return metersPerHourString
            }
        }
    }
}

extension Array where Element: CLLocation {
    func calculateCenterCoordinate() -> CLLocationCoordinate2D {
        let totalLat = self.reduce(0.0) { $0 + $1.coordinate.latitude }
        let totalLong = self.reduce(0.0) { $0 + $1.coordinate.longitude }
        let averageLat = totalLat / Double(self.count)
        let averageLong = totalLong / Double(self.count)
        let calculatedCenterCoordinate = CLLocationCoordinate2D(latitude: averageLat, longitude: averageLong)
        return calculatedCenterCoordinate
    }
}
