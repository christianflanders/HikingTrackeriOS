//
//  WeightPickerViewDataSource.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

class WeightPickerViewDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    let pickerViewTags = PickerViewTags()
    let userPickerHelpers = UserPickerHelpers()

    var weightValueSetDelegate: WeightPickerValueSelectedDelegate?

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return userPickerHelpers.weightPickerData.getWeightPickerViewNumberOfComponents()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userPickerHelpers.weightPickerData.getWeightPickerNumberOfRowsInComponent(component: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userPickerHelpers.weightPickerData.getWeightTitleForRow(row: row, component: component)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let returnTuple = userPickerHelpers.weightPickerData.pickerDidSelectRow(row: row, component: component)
        weightValueSetDelegate?.weightValueSet(stringValue: returnTuple.stringValue, weightInKG: returnTuple.valueInKilograms)
    }


    func setInitialValueForPicker(pickerView: UIPickerView) {
        pickerView.selectRow(100, inComponent: 0, animated: true)
    }

}
