//
//  UserModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/6/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

class User {
    
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
            return defaults.object(forKey: keys.birthdate) as! Date
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
