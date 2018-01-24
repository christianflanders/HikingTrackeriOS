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
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let stringFormatted = dateFormatter.string(from: self)
            return stringFormatted
        }
    }

    var longStringVersionForArchive: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        let stringFormatted = dateFormatter.string(from: self)
        return stringFormatted
    }
    
    var displayStringWithoutTime: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let stringFormatted = dateFormatter.string(from: self)
            return stringFormatted
        }
    }

    var displayStringWithoutTimeShorter: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let stringFormatted = dateFormatter.string(from: self)
            return stringFormatted
        }
    }
    var displayTimeOnly: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            let stringFormatted = dateFormatter.string(from: self)
            return stringFormatted
        }
    }
    
    var getSecondsAsInt: Int {
        get {
            let calendar = Calendar.current
            let seconds = calendar.component(.second, from: self)
            return seconds
        }
    }
}
