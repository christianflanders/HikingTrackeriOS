//
//  Meters Alias.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/11/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

typealias Meters = Double
typealias Miles = Double
typealias Feet = Double


extension Meters {
    var asMiles: Miles {
        get {
            let mileConversion = 0.00062137
            return self * mileConversion
        }
    }
    
    var asFeet: Feet {
        get {
            let feetConversion = 3.2808
            return self * feetConversion
        }
    }
}

extension Meters {
    
    var getDisplayString: String {
        get {
            let feetConversion = 3.2808
            let user = StoredUser()
            let userPreference = user.userDisplayUnits
            if userPreference == .freedomUnits {
                let feetToMilesConversion = 0.00018939
                let convertedToFeet = self * feetConversion
                if convertedToFeet > 2000 {
                    let miles = convertedToFeet * feetToMilesConversion
                    let stringMiles = String(format: "%.2f", miles)
                    return "\(stringMiles) miles"
                } else {
                    let feet = String(Int(convertedToFeet))
                    return "\(feet) ft"
                }
            } else {
                let metersInAKilometer = 1000.0
                if self > metersInAKilometer {
                    let kilometers = self / metersInAKilometer
                    let kilometersTruncated = String(format:"%.2f", kilometers)
                    let displayStringKilometers = "\(kilometersTruncated) km"
                    return displayStringKilometers
                } else {
                    let meters = String(Int(self))
                    return "\(meters) mtrs"
                }
            }
        }
    }
    
    var getMetersOrFeetOnly: String {
        get {
            let feetConversion = 3.2808
            let user = StoredUser()
            let userPreference = user.userDisplayUnits
            if userPreference == .freedomUnits {
                let feetToMilesConversion = 0.00018939
                let convertedToFeet = self * feetConversion
                    let feet = String(Int(convertedToFeet))
                    return "\(feet) ft"
            } else {
                let metersInAKilometer = 1000.0
                if self > metersInAKilometer {
                    let kilometers = self / metersInAKilometer
                    let kilometersTruncated = String(format:"%.2f", kilometers)
                    let displayStringKilometers = "\(kilometersTruncated) km"
                    return displayStringKilometers
                } else {
                    let meters = String(Int(self))
                    return "\(meters) mtrs"
                }
            }
        }
    }
    
    var getDisplayPerHour: String {
        get {
            let metersToMileConversion = 0.00062137
            switch  StoredUser().userDisplayUnits {
            case .freedomUnits:
                let milesPerHour = Int(self * metersToMileConversion)
                let milesPerHourString = "\(milesPerHour) mph"
                return milesPerHourString
            case .metric:
                let meterPerHour = Int(self)
                let metersPerHourString = "\(meterPerHour) mtr/hr"
                return metersPerHourString
            }
        }
    }
}
