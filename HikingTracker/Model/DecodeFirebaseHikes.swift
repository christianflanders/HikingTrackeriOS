//
//  DecodeFirebaseHikes.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/6/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation



class DecodedHike {
    var storedLocations = [CLLocation]()
    private let locationKeys = Location()
    private let firebaseKeys = FirebaseDict()
    var startDate: Date?
    var endDate: Date?
    var caloriesBurned: Double?
    var durationInSeconds: Double?
    var totalElevationDifferenceInMeters: Double?
    var minAlitudeInMeters: Double?
    var maxAltitudeInMeters: Double?
    var timeDownhillInSeconds: Double?
    var timeUphillInSeconds: Double?
    
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
        let convertedDate = convertStringDateToDate(string: startDateString)
        self.startDate = convertedDate
        
        let endDateString = fromFirebaseDict[firebaseKeys.endDateKey] as! String
        let convertedEndDate = convertStringDateToDate(string: endDateString)
        self.endDate = convertedEndDate
        
        let caloriesBurnedDouble = fromFirebaseDict[firebaseKeys.caloriesBurnedKey] as! Double
        self.caloriesBurned = caloriesBurnedDouble
        
        let durationInSecondsDouble = fromFirebaseDict[firebaseKeys.durationInSecondsKey] as! Double
        self.durationInSeconds = durationInSecondsDouble
        
        self.totalElevationDifferenceInMeters = fromFirebaseDict[firebaseKeys.totalElevationInMetersKey] as! Double
        
        self.minAlitudeInMeters = fromFirebaseDict[firebaseKeys.minAltitudeInMetersKey] as!  Double
        
        self.maxAltitudeInMeters = fromFirebaseDict[firebaseKeys.maxAltitudeInMetersKey] as! Double
        
        self.timeUphillInSeconds = fromFirebaseDict[firebaseKeys.timeUphillInSecondsKey] as! Double
        self.timeDownhillInSeconds = fromFirebaseDict[firebaseKeys.timeDownhillInSecondsKey] as! Double
        
        
        
    }
    
    func convertFirebaseLocations(_ locations: [[String:Any]]) -> [CLLocation] {
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
