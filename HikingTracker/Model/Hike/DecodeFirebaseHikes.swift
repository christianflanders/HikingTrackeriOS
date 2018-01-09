//
//  DecodeFirebaseHikes.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/6/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation



class DecodedHike: HikeInformation {
    
    var storedLocations = [CLLocation]()
    var startDate: Date?
    
    var endDate: Date?
    
    var caloriesBurned: Double = 0
    
    var durationInSeconds: Double = 0
    
    var totalElevationDifferenceInMeters: Double = 0
    
    var lowestAltitudeInMeters: Double = 0
    
    var highestAltitudeInMeters: Double = 0
    
    var timeDownhillInSeconds: Double = 0
    
    var timeUphillInSeconds: Double = 0
    
    var totalDistanceInMeters: Double = 0
    
    var currentAltitudeInMeters: Double = 0
    
    var coordinates: [CLLocationCoordinate2D] {
        return storedLocations.map { return $0.coordinate }
    }
    

    private let locationKeys = Location()
    private let firebaseKeys = FirebaseDict()
    
    func convertStringDateToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let dateFromString = dateFormatter.date(from: string)
        return dateFromString
    }
    
    init(fromFirebaseDict: [String: Any]) {
        
        var locations = fromFirebaseDict[firebaseKeys.storedLocationsKey] as! [[String : Any]]
        self.storedLocations = convertFirebaseLocations(locations)
        
        let startDateString = fromFirebaseDict[firebaseKeys.startDateKey] as! String
        let convertedDate = self.convertStringDateToDate(string: startDateString)
        self.startDate = convertedDate
        
        let endDateString = fromFirebaseDict[firebaseKeys.endDateKey] as! String
        let convertedEndDate = self.convertStringDateToDate(string: endDateString)
        self.endDate = convertedEndDate
        
        let caloriesBurnedDouble = fromFirebaseDict[firebaseKeys.caloriesBurnedKey] as! Double
        self.caloriesBurned = caloriesBurnedDouble
        
        let durationInSecondsDouble = fromFirebaseDict[firebaseKeys.durationInSecondsKey] as! Double
        self.durationInSeconds = durationInSecondsDouble
        
        self.totalElevationDifferenceInMeters = fromFirebaseDict[firebaseKeys.totalElevationInMetersKey] as! Double
        
        self.lowestAltitudeInMeters = fromFirebaseDict[firebaseKeys.minAltitudeInMetersKey] as!  Double
        
        self.highestAltitudeInMeters = fromFirebaseDict[firebaseKeys.maxAltitudeInMetersKey] as! Double
        
        self.timeUphillInSeconds = fromFirebaseDict[firebaseKeys.timeUphillInSecondsKey] as! Double
        self.timeDownhillInSeconds = fromFirebaseDict[firebaseKeys.timeDownhillInSecondsKey] as! Double
        
        
        
    }
    
    func convertFirebaseLocations(_ locations: [[String: Any]]) -> [CLLocation] {
        var convertedLocations = [CLLocation]()
        for dict in locations {
            let longitude = dict[locationKeys.longitudeKey] as! Double
            let latitude = dict[locationKeys.latitudeKey] as! Double
            let altitude = dict[locationKeys.altitudeKey] as! Double
            let speed = dict[locationKeys.speedInMetersPerSecondKey] as! Double
            let dateString = dict[locationKeys.timestampKey] as! String
            guard let dateStamp = convertStringDateToDate(string: dateString) else {fatalError("Problem with date formatting")}
            let newCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let newLocation = CLLocation(coordinate: newCoordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: speed, timestamp: dateStamp)
            convertedLocations.append(newLocation)
        }

        return convertedLocations
    }
}
