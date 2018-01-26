//
//  ChecklistItem.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/15/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import Firebase

class ChecklistItem {
    var name: String
    var checked: Bool
    var dateAdded: Date

    init(name:String, checked: Bool, dateAdded: Date) {
        self.name = name
        self.checked = checked
        self.dateAdded = dateAdded
    }

    init(snapshot:DataSnapshot) {
        let checkListDict = snapshot.value as? [String:Any] ?? [:]
        name = checkListDict["Name"] as! String
        checked = checkListDict["Checked"] as! Bool
        let dateString = checkListDict["Date"] as! String
        guard let date = ChecklistItem.convertFromArchiveStringToDate(string: dateString) else {
            print("Date got stored incorrectly")
            dateAdded = Date()
            return
        }
        dateAdded = date
    }


    class func convertFromArchiveStringToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        let dateFromString = dateFormatter.date(from: string)
        return dateFromString
    }



}
