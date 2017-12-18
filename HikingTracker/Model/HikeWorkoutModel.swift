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

class HikeWorkout {
    
    init() {
        print("Hike Workout is being created")
    }
    
    deinit {
        print("Hike workout is being de-created..destroyed...something")
    }
    
    let user = User()
    
    var hikeName = ""

    
    //Time Information
//    var seconds = 0
    var startDate : Date?
    var endDate: Date?
    
    var duration: Double {
        let currentDate = Date()
        guard let startDate = startDate else {
            return 0
        }
        let difference = currentDate.timeIntervalSince(startDate)
        return difference
    }
    
     var durationAsString: String {

        let seconds = Int(duration)
        var stringMinutes = ""
        var stringSeconds = ""
        var stringHours = ""
        let calculatedSeconds = seconds % 60
        if calculatedSeconds < 10 {
            stringSeconds = String("0\(calculatedSeconds)")
        } else {
            stringSeconds = String(calculatedSeconds)
        }
        let calculatedMinutes = seconds / 60
        if calculatedMinutes < 10 {
            stringMinutes = String("0\(calculatedMinutes % 60)")
        } else {
            stringMinutes = String(calculatedMinutes % 60)
        }
        let calculatedHours = calculatedMinutes / 60
        if calculatedHours < 10 {
            stringHours = String("0\(calculatedHours)")
        } else {
            stringHours = String(calculatedHours)
        }
        let calculatedDurationString = "\(stringHours):\(stringMinutes):\(stringSeconds)"
        return calculatedDurationString
    }
    
    var timeTraveldUpHill = 0.0
    var timeTraveledDownHill = 0.0

    
    
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
            if i.altitude < lastLocation.altitude  {
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
    
    var totalCaloriesBurned: Double {
        var totalCaloriesBurned: Double = 0.0
        guard let userWeight = user.weightInKilos else {return 0}
        print(userWeight)
        
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
    
    var lastLocation: CLLocation? {
        willSet (newLocation) {
            guard let lastLocationSet = lastLocation else {return}
            guard let newLocationToSet = newLocation else {return}
            //Check if we're going up or down hill and add that to our time traveled in either direction
            let lastLocationTime = lastLocationSet.timestamp
            if lastLocationSet.altitude < newLocationToSet.altitude {
                timeTraveldUpHill += Double(newLocationToSet.timestamp.timeIntervalSince(lastLocationTime))
            } else if lastLocationSet.altitude > newLocationToSet.altitude {
                timeTraveledDownHill += Double(newLocationToSet.timestamp.timeIntervalSince(lastLocationTime))
            }
            //Add the previous location to our stored Locations
            storedLocations.append(lastLocationSet)
        }
    }
    

    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
    }

}


enum hikeState {
    case notStarted
    case paused
    case started
    case finished
}
