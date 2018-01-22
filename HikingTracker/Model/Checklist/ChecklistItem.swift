//
//  ChecklistItem.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/15/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation

class ChecklistItem {
    var name: String
    var checked: Bool
    var dateAdded: Date

    init(name:String, checked: Bool, dateAdded: Date) {
        self.name = name
        self.checked = checked
        self.dateAdded = dateAdded
    }

}
