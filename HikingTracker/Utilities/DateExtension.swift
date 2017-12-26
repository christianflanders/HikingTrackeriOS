//
//  DateExtension.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/23/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

extension Date {
    var displayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let stringFormatted = dateFormatter.string(from: self)
        return stringFormatted
    }
    
    var displayStringWithoutTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let stringFormatted = dateFormatter.string(from: self)
        return stringFormatted
    }
    var displayTimeOnly: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let stringFormatted = dateFormatter.string(from: self)
        return stringFormatted
    }
}
