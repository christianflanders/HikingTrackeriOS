//
//  UserModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/6/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

class User {
    
    var weightInKilos = 0.0
    var heightInMeters = 0.0
    var age = 0
    var sex: Sex
    
    init(weightInKilos: Double, heightInMeters: Double, age: Int, sex: Sex) {
        self.weightInKilos = weightInKilos
        self.heightInMeters = heightInMeters
        self.age = age
        self.sex = sex
    }
    
    
    
    
    enum Sex {
        case male
        case female
        case other
        
    }
}
