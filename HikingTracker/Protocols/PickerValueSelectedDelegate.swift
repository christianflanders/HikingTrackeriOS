//
//  PickerValueSelectedDelegate.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/23/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

protocol HeightPickerValueSelectedDelegate {
    func heightValueSet(stringValue: String, heightInCM: Double)
}

protocol WeightPickerValueSelectedDelegate {
    func weightValueSet(stringValue: String, weightInKG: Double)
}

protocol GenderPickerValueSelectedDelegate {
    func valueSet(gender: String)
}

protocol BirthdateSelectedDelegate {
    func valueSet(birthdate: Date)
}


