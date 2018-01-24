//
//  GenderPickerDataSource.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

class GenderPickerViewDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    let pickerViewTags = PickerViewTags()
    let userPickerHelpers = UserPickerHelpers()

    var genderSelectedDelegate: GenderPickerValueSelectedDelegate?


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return userPickerHelpers.genderPickerData.getGenderPickerViewNumberOfComponents()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userPickerHelpers.genderPickerData.getGenderPickerNumberOfRowsInComponent(component: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return userPickerHelpers.genderPickerData.getGenderTitleForRow(row: row, component: component)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let genderSelected = GenderOptions().allOptions[row]
        genderSelectedDelegate?.valueSet(gender: genderSelected)
    }




}
