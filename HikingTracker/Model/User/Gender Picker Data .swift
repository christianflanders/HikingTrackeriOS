//
//  Gender Picker Data Source.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/22/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

struct GenderPickerViewData {

    let genderOptions = ["Male", "Female", "Other"]

    // MARK: Number Of Components
    func getGenderPickerViewNumberOfComponents() -> Int {
        return 1
    }



    // MARK: Number of rows in component

    func getGenderPickerNumberOfRowsInComponent(component: Int) -> Int {
        return genderOptions.count
    }


    // MARK: Title For Row

    func getGenderTitleForRow(row: Int, component: Int) ->  String {
        return genderOptions[row]
    }



}
