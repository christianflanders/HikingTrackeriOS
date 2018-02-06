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
    private var weightShown = false
    private var heightShown  = false
    private var genderShown = false
    private var dateShown = false

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        genderPickerView.dataSource = self
//        weightPickerView.dataSource = self
        heightPickerView.dataSource = heightPickerViewDataSource
        heightPickerView.delegate = heightPickerViewDataSource

        

        weightPickerView.dataSource = weightPickerViewDataSource
        weightPickerView.delegate = weightPickerViewDataSource


        genderPickerView.dataSource = genderPickerViewDataSource
        genderPickerView.delegate = genderPickerViewDataSource

        birthDatePickerView.datePickerMode = .date
        birthDatePickerView.maximumDate = Date()


        

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
        if !weightShown {
            weightPickerViewDataSource.setInitialValueForPicker(pickerView: weightPickerView)
            weightShown = true
        }
        weightPickerView.isHidden = false
        heightPickerView.isHidden = true
        birthDatePickerView.isHidden = true
        genderPickerView.isHidden = true
        
    }

    func showHeightPicker() {
        if !heightShown {
            heightPickerViewDataSource.setInitialValueForPicker(pickerView: heightPickerView)
            heightShown = true
        }
        weightPickerView.isHidden = true
        heightPickerView.isHidden = false
        birthDatePickerView.isHidden = true
        genderPickerView.isHidden = true
    }

    func showBirthDatePicker() {
        if !dateShown {
            getBirthdayPickerValue()
            dateShown = true
        }
        weightPickerView.isHidden = true
        heightPickerView.isHidden = true
        birthDatePickerView.isHidden = false
        genderPickerView.isHidden = true
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let newDate = sender.date
        birthDateSelectedDelegate?.valueSet(birthdate: newDate)
    }

    func getBirthdayPickerValue() {
        if let birthday = StoredUser().birthdate {
            birthDatePickerView.setDate(birthday, animated: true)
            birthDateSelectedDelegate?.valueSet(birthdate: birthday)
        } else {
            let birthdatePickerViewInitialDate = Date(timeIntervalSinceReferenceDate: 0)
            birthDatePickerView.setDate(birthdatePickerViewInitialDate, animated: true)
            birthDateSelectedDelegate?.valueSet(birthdate: birthdatePickerViewInitialDate)
        }
    }

}
