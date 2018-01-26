//
//  String Date Extension.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/26/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


extension String {
    func removePossibleLastName() -> String {
        var stringToTruncate = self
        var stringToReturn = self
        if stringToTruncate.first == " " {
            stringToTruncate.removeFirst()
        }
        if stringToTruncate.contains(" ") {
            let cutString = stringToTruncate.prefix(while: { (character) -> Bool in
                return character != " "
            })
            stringToReturn = String(cutString)
        }
        return stringToReturn
    }
}
