//
//  UserInformationValues.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/31/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation

struct UserInformationValues {
    
    var heightInMeters: Double?
    var gender: String?
    var name: String?
    var weightInKG: Double?
    var birthdate: Date?

    var allValuesSet: Bool {
        switch (heightInMeters, gender, name, weightInKG, birthdate) {

        case let (_?, _?, _?, _?, _?) : // if they all have values, return true. Swifts syntax is confusing here
            return true
        default:
            return false
        }
    }
}



struct UserPickerHelpers {

    let heightPickerData = HeightPickerViewData()


    let numberOfComponentsForGenderTag = 1
    let numberOfComponentsForWeightTag = 2

    let pickerViewGenderOptions = ["Male", "Female", "Other"]
    let pickerViewHeightImperialOptions = ["ft", "in"]
    let pickerViewHeightMetricOptions = ["meters"]

    let pickerViewWeightImperialOptions = ["lbs"]
    let pickerViewWeightMetricOptions = ["Kg"]

    func pickerViewTitleForRowForGender(row:Int, component: Int) -> String {
        return pickerViewGenderOptions[row]
    }





}


 struct HeightPickerViewData {

    private let numberOfRowsForFeet = 8 // Increase to add more feet options..but 8 feet should be enough. will give 1-8 feet
    private let numberOfRowsForFeetLabel = 1 // Just adds space for the "Ft" label in component 2
    private let numberOfRowsForInches = 12 // 0-11 inches are the options
    private let numberOfRowsForInchesLabel = 1
    private var imperialArrayOfValues: [Int]

    private let numberOfRowsForCM = 300
    private let numberOfRowsForCMLabel = 1
    private var allMetricOptions: [Int]


    init() {
        imperialArrayOfValues = [numberOfRowsForFeet,numberOfRowsForFeetLabel,numberOfRowsForInches,numberOfRowsForInchesLabel]
        allMetricOptions = [numberOfRowsForCM, numberOfRowsForCMLabel]
    }

    // MARK: Public facing methods

    //Called for pickerView NumberOfComponents. returns the correct number for metric or imperial
    func getHeightPickerViewNumberOfComponents() -> Int {

        let userUnits = StoredUser().userDisplayUnits
        if userUnits == .freedomUnits {
            return imperialArrayOfValues.count
        } else {
            return allMetricOptions.count
        }
    }

    //Called for picker of view number of rows in component.
    func getHeightPickerViewNumberOfRows(component: Int) -> Int {
        var numberOfRowsReturn: Int
        if StoredUser().userDisplayUnits == .freedomUnits {
            numberOfRowsReturn = getHeightPickerViewNumberOfRowsForImperial(component: component)
        } else {
            numberOfRowsReturn = getHeightPickerViewNumberOfRowsForMetric(component: component)
        }
        return numberOfRowsReturn
    }


    func pickerTitleForHeight(row: Int, component: Int) -> String {
        var titleForRowString = ""
        let userUnits = StoredUser().userDisplayUnits
        if userUnits == .freedomUnits {
            titleForRowString = pickerViewTitleForHeightForImperial(row: row, component: component)
        } else if userUnits == .metric {
            titleForRowString = pickerViewTitleForHeightForMetric(row: row, component: component)
        }
        return titleForRowString
    }

    let componentFeetNumberRow = 0
    let componentFeetLabelRow = 1
    let componentInchesNumberRow = 2
    let componentInchesLabelRow = 3
    let footRowLabel = "Ft"
    let inchesRowLabel = "In"

    private func pickerViewTitleForHeightForImperial(row: Int, component: Int) -> String {
        var titleForRowReturn = ""
        switch component {
        case componentFeetNumberRow:
            titleForRowReturn = String(row) //Just gives us the number of the row as a string, aka the selected foot
        case componentFeetLabelRow:
            titleForRowReturn = footRowLabel
        case componentInchesNumberRow:
            titleForRowReturn = String(row)
        case componentInchesLabelRow:
            titleForRowReturn = inchesRowLabel
        default:
            fatalError("Problem with height title imperial")
        }
        return titleForRowReturn
    }

//    func pickerViewDidSeletRowAt(row: Int, component: Int) -> (titleForDisplay: String, valueInMeters: Double) {
//        var titleForRowReturn = ""
//        var valueInMeters = 0
//        switch component {
//        case componentFeetNumberRow:
//            titleForRowReturn = String(row)
//        case componentFeetLabelRow:
//            titleForRowReturn = footRowLabel
//        case componentInchesNumberRow:
//            titleForRowReturn = String(row)
//        case componentInchesLabelRow:
//            titleForRowReturn = inchesRowLabel
//        default:
//            fatalError("Problem with height title imperial")
//        }
//        return titleForRowReturn
//    }


    private func pickerViewTitleForHeightForMetric(row: Int, component: Int) -> String {
        var titleForRowReturn = ""
        let componentCMNumberRow = 0
        let componentCMLabelRow = 1
        let centimeterLabelRowLabel = "CM"
        if component == componentCMNumberRow {
            titleForRowReturn = String(row)
        } else if component == componentCMLabelRow {
            titleForRowReturn = centimeterLabelRowLabel
        }
        return titleForRowReturn
    }

    // MARK: Private methods

    private func getHeightPickerViewNumberOfRowsForImperial(component: Int) -> Int {
        return imperialArrayOfValues[component]
    }

    private  func getHeightPickerViewNumberOfRowsForMetric(component: Int) -> Int {
        return allMetricOptions[component]
    }



}
