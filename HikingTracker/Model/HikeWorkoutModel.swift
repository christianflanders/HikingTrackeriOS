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
import Solar


class HikeWorkout {
    
    init() {
    }
    
    deinit {
    }
    
    let user = User()
    
    var hikeName = ""

    private let dateHelper = DateHelper()
    
    
    var paused = false
    //Time Information
//    var seconds = 0
    var startDate : Date?
    var endDate: Date?
    
    var duration: Double = 0
    
    private var calculatedDuration: Double {
        guard let startDate = startDate else { return 0 }
        let currentDate = Date()
        return currentDate.timeIntervalSince(startDate)
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
            if (i.altitude < lastLocation.altitude) && !paused  {
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
            if (lastLocation.altitude < i.altitude || lastLocation.altitude == i.altitude ) && !paused {
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

}


enum hikeState {
    case notStarted
    case paused
    case started
    case finished
}



