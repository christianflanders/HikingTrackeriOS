//
//  UnitConversions.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/29/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

struct UnitConversions {
    
    func convertKilogramsToPounds(grams: Double) -> Double {
        return grams * 2.2046226218
    }
    
    func convertPoundsToKilograms(pounds: Double) -> Double {
        return pounds / 2.2046226218
    }
    
    func convertInchesToCM(inches: Double) -> Double {
        return inches / 0.393701
    }
    
    func convertCMToInches(cm: Double) -> Double {
        return cm * 0.393701
    }
    
    
}
