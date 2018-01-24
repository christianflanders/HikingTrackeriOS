//
//  Weight Picker View Data.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


struct WeightPickerViewData {

    private let imperialUnitTag = "lbs"
    private let metricUnitTag = "kg"

    private let numberOfComponentsForImperial = 2
    private let numberOfComponentsForMetric = 2

    private let valueComponent = 0
    private let tagComponent = 1

    private let numberOfPoundsToDisplay = 600

    private var areFreedomUnits: Bool {
        let userDisplayUnits = StoredUser().userDisplayUnits
        if userDisplayUnits == .freedomUnits {
            return true
        } else {
            return false
        }
    }

    private let numberOfKGToDisplay = 275

    // MARK: Number Of Components
    func getWeightPickerViewNumberOfComponents() -> Int {
        var numberOfComponents: Int
        if areFreedomUnits {
            numberOfComponents = getImperialWeightPickerNumberOfComponents()
        } else {
            numberOfComponents = getMetricWeightPickerNumberOfComponents()
        }
        return numberOfComponents
    }

    private func getImperialWeightPickerNumberOfComponents() -> Int {
        var numberOfComponents: Int
        numberOfComponents = numberOfComponentsForImperial
        return numberOfComponents
    }

    private func getMetricWeightPickerNumberOfComponents() -> Int {
        var numberOfComponents: Int
        numberOfComponents = numberOfComponentsForMetric
        return numberOfComponents
    }

    // MARK: Number of rows in component

    func getWeightPickerNumberOfRowsInComponent(component: Int) -> Int {
        var numberOfRowsInComponent: Int
        if areFreedomUnits {
            numberOfRowsInComponent = getImperialWeightPickerNumberOfRowsInComponent(component: component)
        } else {
            numberOfRowsInComponent = getMetricWeightPickerNumberOfRowsInComponent(component: component)
        }
        return numberOfRowsInComponent
    }

    private func getImperialWeightPickerNumberOfRowsInComponent(component: Int) -> Int {
        var numberOfRowsInComponent: Int
        if component == valueComponent {
            numberOfRowsInComponent = numberOfPoundsToDisplay
        } else if component == tagComponent {
            numberOfRowsInComponent = 1
        } else {
            numberOfRowsInComponent = 0
            fatalError("getImperialWeightPickerNumberOfRowsInComponent failed")
        }
        return numberOfRowsInComponent
    }

    private func getMetricWeightPickerNumberOfRowsInComponent(component: Int) -> Int {
        var numberOfRowsInComponent: Int
        if component == valueComponent {
            numberOfRowsInComponent = numberOfKGToDisplay
        } else if component == tagComponent {
            numberOfRowsInComponent = 1
        } else {
            numberOfRowsInComponent = 0
            fatalError("getMetricWeightPickerNumberOfRowsInComponent failed")
        }
        return numberOfRowsInComponent
    }

    // MARK: Title For Row

    func getWeightTitleForRow(row: Int, component: Int) ->  String {
        var titleForRow: String
        if areFreedomUnits {
            titleForRow = getImperialWeightTitleForRow(row: row, component: component)
        } else {
            titleForRow = getMetricTitleForRow(row: row, component: component)
        }
        return titleForRow
    }

    private func getImperialWeightTitleForRow(row: Int, component: Int) ->  String {
        var titleForRow: String
        if component == valueComponent {
            titleForRow = String(row) 
        } else {
            titleForRow = imperialUnitTag
        }
        return titleForRow
    }

    private func getMetricTitleForRow(row: Int, component: Int) ->  String {
        var titleForRow: String
        if component == valueComponent {
            titleForRow = String(row)
        } else {
            titleForRow = metricUnitTag
        }
        return titleForRow
    }


    func pickerDidSelectRow(row: Int, component: Int) -> (stringValue: String, valueInKilograms: Double) {
        var returnValues = ("", 0.0)
        if areFreedomUnits {
            returnValues = pickerDidSelectRowImperial(row: row, component: component)
        } else {
            returnValues = pickerDidSelectRowMetric(row: row, component: component)
        }
        return returnValues
    }

    private func pickerDidSelectRowImperial(row: Int, component: Int) -> (stringValue: String, valueInKilograms: Double) {
        var returnValues = ("", 0.0)
        let conv = UnitConversions()
        let selectedPoundValue = row
        if component == valueComponent {
            returnValues.0 = "\(selectedPoundValue) \(imperialUnitTag)"
            let lbsDoubleValue = Double(selectedPoundValue)
            let convertedToKG = conv.convertPoundsToKilograms(pounds: lbsDoubleValue)
            returnValues.1 = convertedToKG
        }
        return returnValues
    }

    private func pickerDidSelectRowMetric(row: Int, component: Int) -> (stringValue: String, valueInKilograms: Double) {
        var returnValues = ("", 0.0)
        let conv = UnitConversions()
        let selectedKGValue = row
        if component == valueComponent {
            returnValues.0 = "\(selectedKGValue) \(metricUnitTag)"
            returnValues.1 = Double(selectedKGValue)
        }
        return returnValues
    }
    
}
