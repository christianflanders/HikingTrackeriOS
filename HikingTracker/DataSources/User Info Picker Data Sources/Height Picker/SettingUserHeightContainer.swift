//
//  SettingUserHeightContainer.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation

struct UserHeightContainer {


    private var stringToDisplay = ""

    private let conv = UnitConversions()


    private let componentsTag = PickerViewTags()

    private let displayUnits = StoredUser().userDisplayUnits

    func pickerDidSelectRow(row: Int, component: Int) -> (stringForDisplay: String, valueInCM: Double) {
        var selectedValues = (stringToDisplay, 0)()
        if displayUnits == .freedomUnits {
            selectedValues = pickerDidSelectRowForImperial(row: row, component: component)
        } else {
            selectedValues = pickerDidSelectRowForMetric(row: row, component: component)
        }
        return selectedValues
    }

    private let componentFeetNumberRow = 0
    private let componentFeetLabelRow = 1
    private let componentInchesNumberRow = 2
    private let componentInchesLabelRow = 3

    private var heightFeetValue = 0 // Set when a new row is selected
    private let heightFeetLabel = "Feet"
    private var heightInchValue = 0 // set when a new row is selected
    private let heightInchLabel = "Inches"

    private func pickerDidSelectRowForImperial(row: Int, component: Int) -> (stringForDisplay: String, valueInCM: Double) {
        var returnTuple = ("", 0)
        if component == componentFeetNumberRow {
            heightFeetValue = row
        } else if component == componentInchesNumberRow {
            heightInchValue = row
        }
        returnTuple.0 = "\(heightFeetValue) \(heightFeetLabel), \(heightInchValue) \(heightInchLabel)"
        returnTuple.1 = conv.convertFeetAndInchesToCM(feet: heightFeetValue, inches: heightInchValue)
    }

    private let componentCentimeterNumberRow = 0
    private let componentCentimeterLabelRow = 1

    private func pickerDidSelectRowForMetric(row: Int, component: Int) -> (stringForDisplay: String, valueInCM: Double) {
        var returnTuple = ("", 0)
        if component == componentCentimeterNumberRow {

        }
        return returnTuple
    }


}
