//
//  UserInformationValues.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/31/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

struct UserInformationValues {
    
    var heightInMeters: Double?
    var gender: String?
    var name: String?
    var weightInKG: Double?
    var birthdate: Date?

    var allValuesSet: Bool {
        switch (heightInMeters, gender, name, weightInKG, birthdate) {

        case let (_?, _?, _?, _?, _?) : // if they all have values, return true. Swifts syntax is confusing here
            return true
        default:
            return false
        }
    }
}







