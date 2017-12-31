//
//  UserModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/6/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

class StoredUser {
    
    private let defaults = UserDefaults.standard
    private let keys = UserEntriesKeys()
    
    var weightInKilos: Double? {
        get {
            return defaults.double(forKey: keys.weight)
        }
        set {
            defaults.set(newValue, forKey: keys.weight)
        }
        
    }
    var heightInMeters: Double? {
        get {
            return defaults.double(forKey: keys.height)
        }
        set {
            defaults.set(newValue, forKey: keys.height)
        }
        
    }
    
    var birthdate: Date? {
        get {
            return defaults.object(forKey: keys.birthdate) as? Date
        }
        set {
            defaults.set(newValue, forKey: keys.birthdate) 
        }
    }
    
    var gender: String? {
        get {
            return defaults.string(forKey: keys.gender)
        }
        set {
            defaults.set(newValue, forKey: keys.gender)
        }
    }
    
    var name: String? {
        get {
            if let returnName = defaults.string(forKey: keys.name) {
                return returnName
            } else {
                return nil
            }
        }
        set {
            defaults.set(newValue, forKey: keys.name)
        }
    }
    
    var userDisplayUnits: DisplayUnits {
        get {
            let fromDefaults = defaults.object(forKey: keys.localUnits) as! String
            switch fromDefaults {
            case "freedomUnits":
                return .freedomUnits
            case "metric" :
                return .metric
            default:
                print("Unknown value stored in user defaults for display units")
                return .freedomUnits
            }
        }
        set {
            switch newValue {
            case .freedomUnits:
                defaults.set("freedomUnits", forKey: keys.localUnits)
            case .metric:
                defaults.set("metric", forKey: keys.localUnits)
            }
        }
    }
    
    func getWeightForDisplay() -> String {
        let unitConversion = UnitConversions()
        let displayUnit = self.userDisplayUnits
        guard let weight = self.weightInKilos else  {return "N/A"}
        switch displayUnit {
        case .freedomUnits:
            let weightInPounds = unitConversion.convertKilogramsToPounds(grams: weight)
            let weightString = "\(weightInPounds) lbs"
            return weightString
        case .metric:
            let weightString = "\(weight) grams"
            return weightString

        }
    }
    
    func getHeightForDisplay() -> String {
        guard let height = self.heightInMeters else {return "N/A"}
        let displayUnit = self.userDisplayUnits
        let unitConversion = UnitConversions()
        switch displayUnit {
        case .freedomUnits:
            let heightInInches = unitConversion.convertCMToInches(cm: height)
            let feet = Int(heightInInches) / 12
            let inches = Int(heightInInches) % 12
            let heightString = "\(feet)\"\(inches) ft"
            return heightString
        case .metric:
            let heightString = "\(height) cm"
            return heightString
        }
    }
    
    func convertBirthdateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        let stringToSave = dateFormatter.string(from: date)
        return stringToSave
    }
    
//    func convertBirthdateToString(_ string: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .full
//        dateFormatter.timeStyle = .none
//        let dateToReturn = dateFormatter.date(from: string)
//        return dateToReturn!
//    }

}

enum DisplayUnits {
    case metric
    case freedomUnits
}

struct UserEntriesKeys {
    let weight = "weight"
    let height = "height"
    let name = "name"
    let birthdate = "birthdate"
    let gender = "gender"
    let localUnits = "localUnits"
}
