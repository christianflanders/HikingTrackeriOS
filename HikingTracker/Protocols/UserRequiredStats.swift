//
//  UserRequiredStats.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/21/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation

protocol UserRequiredInformation {
    var perferedMeasurementUnit: DisplayUnits {get}
    var heightInMeters: Double {get}
    var weightInKG: Double {get}
    var birthDate: Date {get}
    var gender: GenderOptions {get}
    var name: String {get}

}


