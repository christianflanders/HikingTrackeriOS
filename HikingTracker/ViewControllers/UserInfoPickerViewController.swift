//
//  UserInfoPickerViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/21/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class UserInfoPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    struct PickerViewTags {
        let weightTag = 1
        let heightTag = 2
        let genderTag = 3
    }


    // MARK: Enums

    // MARK: Constants
    let pickerViewTags = PickerViewTags()
    let userPickerHelpers = UserPickerHelpers()

    // MARK: Variables


    // MARK: Outlets

    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var birthDatePickerView: UIDatePicker!


    // MARK: Weak Vars


    // MARK: Public Variables
//    var loadMetricOrImperial: DisplayUnits!
    var whichPickerToDisplay: StoredUserOptions?

    // MARK: Private Variables


    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        genderPickerView.dataSource = self
        weightPickerView.dataSource = self
        heightPickerView.dataSource = self

        genderPickerView.delegate = self
        weightPickerView.delegate = self
        heightPickerView.delegate = self
        
        //TODO: Set user defaults unit value to the locale
        checkLocaleAndSetUnits()

    }



    func checkWhichPickerToDisplay() {
        guard let option = whichPickerToDisplay else { return }
        switch option {
        case .weight:
            showWeightPicker()
        case .birthdate:
            showBirthDatePicker()
        case .gender:
            showGenderPicker()
        case .height:
            showHeightPicker()
        }
    }

    // MARK: IBActions

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let parentVC = self.parent as! EditUserInfoViewController
        parentVC.hidePickerVC()
    }


    // MARK: PickerView Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case pickerViewTags.genderTag:
            return userPickerHelpers.numberOfComponentsForGenderTag
        case pickerViewTags.heightTag:
                return userPickerHelpers.heightPickerData.getHeightPickerViewNumberOfComponents()
        case pickerViewTags.weightTag:
            return userPickerHelpers.numberOfComponentsForWeightTag
        default:
            fatalError("Correct Tag missing")
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case pickerViewTags.genderTag:
            return userPickerHelpers.pickerViewGenderOptions.count
        case pickerViewTags.heightTag:
            return userPickerHelpers.heightPickerData.getHeightPickerViewNumberOfRows(component: component)
        case pickerViewTags.weightTag:
            return userPickerHelpers.numberOfComponentsForWeightTag
        default:
            fatalError("Correct Tag missing")
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case pickerViewTags.genderTag:
            return userPickerHelpers.pickerViewTitleForRowForGender(row:row, component:component)
        case pickerViewTags.heightTag:
            return userPickerHelpers.heightPickerData.pickerTitleForHeight(row: row, component: component)
        default:
            return ""
        }
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case pickerViewTags.heightTag:
            <#code#>
        default:
            <#code#>
        }
    }

    //TODO: Start Picker In Middle

    func showGenderPicker() {
        weightPickerView.isHidden = true
        heightPickerView.isHidden = true
        birthDatePickerView.isHidden = true
        genderPickerView.isHidden = false
    }

    func showWeightPicker() {
        weightPickerView.isHidden = false
        heightPickerView.isHidden = true
        birthDatePickerView.isHidden = true
        genderPickerView.isHidden = true
    }

    func showHeightPicker() {
        weightPickerView.isHidden = true
        heightPickerView.isHidden = false
        birthDatePickerView.isHidden = true
        genderPickerView.isHidden = true
    }

    func showBirthDatePicker() {
        weightPickerView.isHidden = true
        heightPickerView.isHidden = true
        birthDatePickerView.isHidden = false
        genderPickerView.isHidden = true
    }




    func checkLocaleAndSetUnits() {
        
    }


}
