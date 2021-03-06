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

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Cabin", size: 26.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = userPickerHelpers.weightPickerData.getWeightTitleForRow(row: row, component: component)

        return pickerLabel!
    }

    func setInitialValueForPicker(pickerView: UIPickerView) {
        if let weightInKG = StoredUser().weightInKilos {
            if weightInKG == 0 {
                pickerView.selectRow(100, inComponent: 0, animated: true)
                pickerView.delegate?.pickerView!(pickerView, didSelectRow: 100, inComponent: 0)
            } else {
                if StoredUser().userDisplayUnits == .metric {
                    let asInt = Int(weightInKG)
                    pickerView.selectRow(asInt, inComponent: 0, animated: true)
                    pickerView.delegate?.pickerView!(pickerView, didSelectRow: asInt, inComponent: 0)
                } else {
                    let conv = UnitConversions()
                    let weightInPounds = conv.convertKilogramsToPounds(grams: weightInKG)
                    let asInt = Int(weightInPounds)
                    pickerView.selectRow(asInt, inComponent: 0, animated: true)
                    pickerView.delegate?.pickerView!(pickerView, didSelectRow: asInt, inComponent: 0)
                }
            }
        } else {
            pickerView.selectRow(100, inComponent: 0, animated: true)
            pickerView.delegate?.pickerView!(pickerView, didSelectRow: 100, inComponent: 0)
        }
    }

}
