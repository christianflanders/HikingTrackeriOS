//
//  Weight Picker View Data.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation


struct WeightPickerViewData {

    private let userDisplayUnits = StoredUser().userDisplayUnits
    private let imperialUnitTag = "lbs"
    private let metricUnitTag = "kg"

    private let numberOfComponentsForImperial = 2
    private let numberOfComponentsForMetric = 2

    private let valueComponent = 0
    private let tagComponent = 1

    private let numberOfPoundsToDisplay = 602// setting this to 602 so we get 600 values, since we're removing 0 because thats not a real option for wewight

    private let numberOfKGToDisplay = 275
    // MARK: Number Of Components
    func getWeightPickerViewNumberOfComponents() -> Int {
        var numberOfComponents: Int
        if userDisplayUnits == .freedomUnits {
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
        if userDisplayUnits == .freedomUnits {
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
        if userDisplayUnits == .freedomUnits {
            titleForRow = getImperialWeightTitleForRow(row: row, component: component)
        } else {
            titleForRow = getMetricTitleForRow(row: row, component: component)
        }
        return titleForRow
    }

    private func getImperialWeightTitleForRow(row: Int, component: Int) ->  String {
        var titleForRow: String
        if component == valueComponent {
            titleForRow = String(row + 1) // Adding 1 so we don't get a value of 0 lbs
        } else {
            titleForRow = imperialUnitTag
        }
        return titleForRow
    }

    private func getMetricTitleForRow(row: Int, component: Int) ->  String {
        var titleForRow: String
        if component == valueComponent {
            titleForRow = String(row + 1) // adding 1 so we dont get a value of 0 kg
        } else {
            titleForRow = metricUnitTag
        }
        return titleForRow
    }
}
