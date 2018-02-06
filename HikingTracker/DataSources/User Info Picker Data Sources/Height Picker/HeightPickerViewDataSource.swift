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
        if let storedHeightInCM = StoredUser().heightInCentimeters {
            if storedHeightInCM == 0 {
                pickerView.selectRow(5, inComponent: 0, animated: true)
                pickerView.delegate?.pickerView!(pickerView, didSelectRow: 5, inComponent: 0)

            } else {
                if StoredUser().userDisplayUnits == .metric {
                    pickerView.selectRow(Int(storedHeightInCM), inComponent: 0, animated: true)
                    pickerView.delegate?.pickerView!(pickerView, didSelectRow: Int(storedHeightInCM), inComponent: 0)
                } else {
                    let conv = UnitConversions()
                    let totalInches = Int(conv.convertCMToInches(cm:storedHeightInCM))
                    let inchesToDisplay = Int(totalInches) % 12
                    let totalFeet = totalInches / 12
                    pickerView.selectRow(totalFeet, inComponent: 0, animated: true)
                    pickerView.selectRow(inchesToDisplay, inComponent: 2, animated: true)
                    pickerView.delegate?.pickerView!(pickerView, didSelectRow: totalFeet, inComponent: 0)
                    pickerView.delegate?.pickerView!(pickerView, didSelectRow: inchesToDisplay, inComponent: 2)
                }
            }
        } else {
            pickerView.selectRow(5, inComponent: 0, animated: true)
            pickerView.delegate?.pickerView!(pickerView, didSelectRow: 5, inComponent: 0)
        }
    }


    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Cabin", size: 26.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = userPickerHelpers.heightPickerData.pickerTitleForHeight(row: row, component: component)

        return pickerLabel!
    }
}
