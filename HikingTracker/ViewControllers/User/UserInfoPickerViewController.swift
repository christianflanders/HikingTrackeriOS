//
//  UserInfoPickerViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/21/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class UserInfoPickerViewController: UIViewController {




    // MARK: Enums

    // MARK: Constants
    let pickerViewTags = PickerViewTags()
    let userPickerHelpers = UserPickerHelpers()


    let heightPickerViewDataSource = HeightPickerViewDataSource()
    let weightPickerViewDataSource = WeightPickerViewDataSource()
    let genderPickerViewDataSource = GenderPickerViewDataSource()

    var birthDateSelectedDelegate: BirthdateSelectedDelegate?

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
//        genderPickerView.dataSource = self
//        weightPickerView.dataSource = self
        heightPickerView.dataSource = heightPickerViewDataSource
        heightPickerView.delegate = heightPickerViewDataSource
        heightPickerViewDataSource.setInitialValueForPicker(pickerView: heightPickerView)
        

        weightPickerView.dataSource = weightPickerViewDataSource
        weightPickerView.delegate = weightPickerViewDataSource
        weightPickerViewDataSource.setInitialValueForPicker(pickerView: weightPickerView)

        genderPickerView.dataSource = genderPickerViewDataSource
        genderPickerView.delegate = genderPickerViewDataSource

        birthDatePickerView.datePickerMode = .date
        birthDatePickerView.maximumDate = Date()
        let birthdatePickerViewInitialDate = Date(timeIntervalSinceReferenceDate: 0)
        birthDatePickerView.setDate(birthdatePickerViewInitialDate, animated: true)
        

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

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let newDate = sender.date
        birthDateSelectedDelegate?.valueSet(birthdate: newDate)
    }


}
