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
        let mileConversion = 0.00062137
        return self * mileConversion
    }
    
    var asFeet: Feet {
        let feetConversion = 3.2808
        return self * feetConversion
        
    }
    
}

extension Meters {
    
    var getDisplayString: String {
        let feetConversion = 3.2808
        let user = User()
        let userPreference = user.userDisplayUnits
        if userPreference == .freedomUnits {
            let convertedToFeet = Int(self * feetConversion)
            let feet = String(convertedToFeet)
            return "\(feet) ft"
        } else {
            let meters = String(Int(self))
            return "\(meters) mtrs"
        }
        
    }
}
