//
//  UserModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/6/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

class User {

    
    var weightInKilos: Double? {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: "weight")
    }
    var heightInMeters: Double? {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: "height")
    }
    var name: String? {
        let defaults = UserDefaults.standard
        if let returnName = defaults.string(forKey: "name") {
            return returnName
        } else {
            return nil
        }
        
    }

    
    
    
    
    
    
 
}
