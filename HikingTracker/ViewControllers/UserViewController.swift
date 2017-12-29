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
    
    private var selectedStat: UserInputs?
    

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
        
    }

    // MARK: IBActions
    
    @IBAction func pickerDoneButtonPressed(_ sender: UIButton) {
        hidePicker()
        hideDatePicker()
        showButtons()
    }
    
    @IBAction func weightButttonPressed(_ sender: UIButton) {

    }
    
    @IBAction func heightButtonPressed(_ sender: UIButton) {
        showPickerViewFor(.weight)
    }
    
    @IBAction func sexButtonPressed(_ sender: UIButton) {
        showPickerViewFor(.gender)

    }
    
    @IBAction func birthdayButtonPressed(_ sender: UIButton) {
                showPickerViewFor(.birthdate)
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
        guard let rowSelected = selectedStat else {return 0}
        switch rowSelected {
        case .gender:
            return 1
        
        default:
            return 10
        }
        return 10
    }
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Boobies"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
    
    // MARK: UIDatePickerView
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {

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


}
