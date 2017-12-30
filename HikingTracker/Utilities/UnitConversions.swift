//
//  UnitConversions.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/29/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

struct UnitConversions {
    
    func convertGramsToPounds(grams: Double) -> Double {
        return grams * 0.0022046
    }
    
    func convertPoundsToGrams(pounds: Double) -> Double {
        return pounds / 0.0022046
    }
    
    func convertInchesToCM(inches: Double) -> Double {
        return inches / 0.39370
    }
    
    func convertCMToInches(cm: Double) -> Double {
        return cm * 0.39370
    }
    
    
}
