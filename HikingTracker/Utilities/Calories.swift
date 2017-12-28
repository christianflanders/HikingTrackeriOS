//
//  Calories.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/27/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

typealias Calorie = Double

extension Calorie {
    var getCalorieDisplayString: String {
        let shortened = Int(self)
        let string = "\(shortened) klc"
        return string
    }
}
