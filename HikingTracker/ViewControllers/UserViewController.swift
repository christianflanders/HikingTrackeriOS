//
//  UserViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,
UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Enums
    enum UserInputs {
        case name
        case height
        case gender
        case birthdate
        case weight
    }
    
    // MARK: Constants
    private let userOptions = [0 : "Name", 1 : "Gender", 2 : "Birthdate", 3 :  "Weight"]
    private let enumOptions = [0 : UserInputs.name, 1 : UserInputs.gender, 2 : UserInputs.birthdate, 3 :  UserInputs.weight]
    
    private let genderOptions = ["Male", "Female"]
    private let heightOptions = ["ft", "meters"]
    private let weightOptions = ["lbs", "kg"]
    
    
    private let usaLocale = "es_US"
    
    private let user = User()
    
    // MARK: Variables
    
    // MARK: Outlets
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerContainerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var nameButtonOutlet: UILabel!
    @IBOutlet weak var weightButtonOutlet: UIButton!
    @IBOutlet weak var heightButtonOutlet: UIButton!
    @IBOutlet weak var sexButtonOutlet: UIButton!
    @IBOutlet weak var birthdayButtonOutlet: UIButton!
    
    @IBOutlet weak var saveImportButtonStack: UIStackView!
    
    
    // MARK: Weak Vars
    
    // MARK: Public Variables
    
    // MARK: Private Variables
    private var weightVaule = 0
    private var weightUnit = ""
    
    private var heightValue = ""
    private var heightInchValue = ""
    private var setHeightString = ""
    
    private var genderVaule = ""
    
    
    private var selectedStat: UserInputs?
    
    private var nameSet = false
    private var weightSet = false
    private var heightSet = false
    private var birthdaySet = false
    private var genderSet = false
    
    private var defaultLocale: Locale!
    private var displayUnits: DisplayUnits {
        return user.userDisplayUnits
    }
    private var weightDisplayUnit = ""
    private var heightDisplayUnit = ""
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerContainerView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        datePicker.maximumDate = Date()
        hideDatePicker()
        hidePicker()
        showButtons()
        defaultLocale = Locale.current
        if defaultLocale.usesMetricSystem {
            setUnitsToCommunist()
        } else {
            setUnitsToFreedom()
        }

    }
    
    // MARK: IBActions
    
    @IBAction func pickerDoneButtonPressed(_ sender: UIButton) {
        checkWhichStatAndMarkAsSet()
        hidePicker()
        hideDatePicker()
        showButtons()
    }
    
    @IBAction func weightButttonPressed(_ sender: UIButton) {
        showPickerViewFor(.weight)
        pickerView.reloadAllComponents()

    }
    
    @IBAction func heightButtonPressed(_ sender: UIButton) {
        showPickerViewFor(.height)
        pickerView.reloadAllComponents()

    }
    
    @IBAction func sexButtonPressed(_ sender: UIButton) {
        showPickerViewFor(.gender)
        pickerView.reloadAllComponents()

        
    }
    
    @IBAction func birthdayButtonPressed(_ sender: UIButton) {
        showPickerViewFor(.birthdate)
        pickerView.reloadAllComponents()

    }
    
    func showPickerViewFor(_ input: UserInputs) {
        
        selectedStat = input
        if input == .birthdate {
            hideButtons()
            hidePicker()
            showDatePicker()
        } else {
            hideButtons()
            hideDatePicker()
            showPicker()
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let rowSelected = selectedStat else {return 5}
        switch rowSelected {
        case .gender:
            return 1
        case .weight:
            return 1
        case .height:
            if displayUnits == .freedomUnits {
                return 2
            } else {
                return 1
            }
        default:
            return 10
        }
        return 10
    }
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let rowSelected = selectedStat else {return 5}
        switch rowSelected {
        case .weight:
            return 600
        case .height:
            if displayUnits == .freedomUnits {
                if component == 0 {
                    return 9
                } else {
                    return 11
                }
            } else {
                return 275
            }
        case .gender:
            return genderOptions.count
        default:
            return 2
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let rowSelected = selectedStat else {return " "}
        switch rowSelected {
        case .weight:
            if component == 0 {
                return String(row)
            } else {
                return weightOptions[row]
            }
        case .height:
            return String(row)
        case .gender:
            return genderOptions[row]
        default:
            return " "
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let rowSelected = selectedStat else {return}
        switch rowSelected {
        case .weight:
            weightVaule = row
            let combinedString = "\(weightVaule) \(weightDisplayUnit)"
            weightButtonOutlet.setTitle(combinedString, for: .normal)
            
        case .height:
            if component == 0 {
                heightValue = String(row)
            } else if component == 1 {
                heightInchValue = String(row)
            }
            if displayUnits == .freedomUnits {
                setHeightString = "\(heightValue)\"\(heightInchValue) ft"
            } else {
                setHeightString = "\(heightValue) cm"
            }
            heightButtonOutlet.setTitle(setHeightString, for: .normal)
            
        case .gender :
            genderVaule = genderOptions[row]
            sexButtonOutlet.setTitle(genderVaule, for: .normal)
            
            //put shit here
        default:
            print("should not have hit default")
        }
    }
    
    // MARK: UIDatePickerView
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        birthdayButtonOutlet.setTitle(sender.date.displayStringWithoutTime, for: .normal)
        
    }
    
    // MARK: Showing/Hiding Functions
    
    private func hideButtons() {
        saveImportButtonStack.isHidden = true
        doneButtonOutlet.isHidden = false
        
    }
    
    private func showButtons() {
        saveImportButtonStack.isHidden = false
        doneButtonOutlet.isHidden = true
        
    }
    
    private func showDatePicker() {
        pickerContainerView.isHidden = false
        doneButtonOutlet.isHidden = false
        datePicker.isHidden = false
    }
    
    private func hideDatePicker() {
        pickerContainerView.isHidden = true
        doneButtonOutlet.isHidden = true
        datePicker.isHidden = true
    }
    
    private func showPicker() {
        pickerContainerView.isHidden = false
        doneButtonOutlet.isHidden = false
        pickerView.isHidden = false
    }
    
    private func hidePicker() {
        pickerContainerView.isHidden = true
        doneButtonOutlet.isHidden = true
        pickerView.isHidden = true
    }
    
    
    func checkWhichStatAndMarkAsSet() {
        guard let whichSet = selectedStat else {return}
        switch whichSet {
        case .weight:
            weightSet = true
        case .height:
            heightSet  = true
        case .gender:
            genderSet = true
        default:
            print("Probably shouldnt have hit default here")
        }
    }
    
    
    
    // MARK: Local Units
    
    func setUnitsToFreedom() {
        user.userDisplayUnits = .freedomUnits
        weightDisplayUnit = "lbs"
        heightDisplayUnit = "ft"
    }
    
    func setUnitsToCommunist() {
        user.userDisplayUnits = .metric
        weightDisplayUnit = "grams"
        heightDisplayUnit = "cm"
    }
}
