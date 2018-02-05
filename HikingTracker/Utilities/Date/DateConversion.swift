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
        let timeFormattter = DateComponentsFormatter()
        timeFormattter.unitsStyle = .positional
        timeFormattter.allowedUnits = [.hour, .minute, .second]
        timeFormattter.zeroFormattingBehavior = .pad
        guard let formattedDuration = timeFormattter.string(from:duration ) else { return "-" }
        return formattedDuration
    }
}
