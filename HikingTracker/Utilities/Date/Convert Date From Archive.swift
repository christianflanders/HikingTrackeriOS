//
//  Convert Date From Archive.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/20/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


struct ConvertDate {
    func fromArchiveString(_ archiveString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        return dateFormatter.date(from: archiveString)!
    }
}
