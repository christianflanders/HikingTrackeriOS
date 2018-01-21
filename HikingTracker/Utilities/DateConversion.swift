//
//  DateConversion.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

class DateHelper {
    
    func convertDurationToStringDate(_ duration: Double) -> String {
        let seconds = Int(duration)
        
        var stringMinutes = ""
        var stringSeconds = ""
        var stringHours = ""
        let calculatedSeconds = seconds % 60
        if calculatedSeconds < 10 {
            stringSeconds = String("0\(calculatedSeconds)")
        } else {
            stringSeconds = String(calculatedSeconds)
        }
        let calculatedMinutes = seconds / 60
        if calculatedMinutes == 0 {
            stringMinutes == "00"
        }
        if calculatedMinutes < 10 {
            stringMinutes = String("0\(calculatedMinutes % 60)")
        } else {
            stringMinutes = String(calculatedMinutes % 60)
        }
        let calculatedHours = calculatedMinutes / 60
        if calculatedHours < 10 {
            stringHours = String("0\(calculatedHours)")
        } else {
            stringHours = String(calculatedHours)
        }
        let calculatedDurationString = "\(stringHours):\(stringMinutes):\(stringSeconds)"
        return calculatedDurationString
    }
}
