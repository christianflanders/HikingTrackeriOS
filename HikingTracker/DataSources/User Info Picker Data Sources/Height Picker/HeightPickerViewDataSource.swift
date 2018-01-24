//
//  HeightPickerViewDataSource.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

class HeightPickerViewDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    private let pickerViewTags = PickerViewTags()
    private let userPickerHelpers = UserPickerHelpers()

    private var userHeightContainer = UserHeightContainer()

    var heightValueSetDelegate: HeightPickerValueSelectedDelegate?

    var stringForDisplay = ""
    var valueInCM = 0.0


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return userPickerHelpers.heightPickerData.getHeightPickerViewNumberOfComponents()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userPickerHelpers.heightPickerData.getHeightPickerViewNumberOfRows(component: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return userPickerHelpers.heightPickerData.pickerTitleForHeight(row: row, component: component)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let returnTuple = userHeightContainer.pickerDidSelectRow(row: row, component: component)
        stringForDisplay = returnTuple.stringForDisplay
        valueInCM = returnTuple.valueInCM
        heightValueSetDelegate?.heightValueSet(stringValue: stringForDisplay, heightInCM: valueInCM)
    }

    func setInitialValueForPicker(pickerView: UIPickerView) {
        pickerView.selectRow(5, inComponent: 0, animated: true)
    }

}
