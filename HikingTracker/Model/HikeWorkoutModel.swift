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


class HikeWorkoutInProgress {
    
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
        return dateHelper.convertDurationToStringDate(calculatedDuration)

    }
    
    var timeTraveldUpHill = 0.0
    var timeTraveledDownHill = 0.0

    var sunsetTime: String? {
        guard let currentLocation = self.storedLocations.first else { return " " }
        guard let startDate = startDate else {return " "}
        let solar = Solar(for: startDate, coordinate: currentLocation.coordinate)
        guard let sunset = solar?.sunset else { return "" }
        let string = sunset.displayTimeOnly
        
        return string
    }
    
    
    //Elevation & Distance Information
    
    var lowestElevation: Meters {
        guard var lowestAltitude = storedLocations.first?.altitude else {return 0}
        for location in storedLocations {
            if location.altitude < lowestAltitude {
                lowestAltitude = location.altitude
            }
        }
        return Meters(lowestAltitude)
    }
    
    
    var highestElevation: Meters {
        guard var highestAltitude = storedLocations.first?.altitude else {return 0}
        for location in storedLocations {
            if location.altitude > highestAltitude {
                highestAltitude = location.altitude
            }
        }
        return Meters(highestAltitude)
    }
    
    var totalDistanceTraveled: Meters? {
        guard let distanceTraveledUphill = distanceTraveledUphill else {return 0}
        guard let distanceTraveledDownhill = distanceTraveledDownhill else {return 0}
        return distanceTraveledUphill + distanceTraveledDownhill
    }
    
    var distanceTraveledDownhill: Meters? {
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
    
    var distanceTraveledUphill: Meters? {
        var totalDistanceTraveledUphill = 0.0
        guard var lastLocation = storedLocations.first else {return 0.0}
        for i in storedLocations {
            if lastLocation.altitude < i.altitude || lastLocation.altitude == i.altitude {
                totalDistanceTraveledUphill += i.distance(from: lastLocation)
            }
            lastLocation = i
        }
        return totalDistanceTraveledUphill
    }
    
    
        //Calorie Information
    
    private let hikeUphillMETValue = 6.00
    private let hikeDownhillMETValue = 2.8
    
    var totalCaloriesBurned: Calorie {
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
    
    //Locations
    
    var storedLocations = [CLLocation]()
    
    func addNewLocation(_ newLocation: CLLocation) {
        if storedLocations.isEmpty {
            storedLocations.append(newLocation)
            return
        }
        guard let lastLocationSet = storedLocations.last else {return}
        
        
        
        
        
        storedLocations.append(newLocation)
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
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
    
    private func checkIfPausedAndSetPausedDuration(lastLocation: CLLocation, newLocation:CLLocation) {
        let timeDifference = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
        if paused {
            
        }
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
