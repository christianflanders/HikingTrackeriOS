//
//  UserInformationValues.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/31/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

struct UserInformationValues {
    
    var heightInCentimeters: Double?
    var gender: String?
    var name: String?
    var weightInKG: Double?
    var birthdate: Date?

    var allValuesSet: Bool {
        switch (heightInCentimeters, gender, name, weightInKG, birthdate) {

        case  (_?, _?, _?, _?, _?) : // if they all have values, return true. Swifts syntax is confusing here
            return true
        default:
            return false
        }
    }
}







