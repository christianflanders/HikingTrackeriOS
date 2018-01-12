//
//  UserViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController,
    UIPickerViewDataSource, UIPickerViewDelegate,
UITextFieldDelegate {
    
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
    
    private let user = StoredUser()
    
    // MARK: Variables
    
    // MARK: Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerContainerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var weightButtonOutlet: UIButton!
    @IBOutlet weak var heightButtonOutlet: UIButton!
    @IBOutlet weak var sexButtonOutlet: UIButton!
    @IBOutlet weak var birthdayButtonOutlet: UIButton!
    
    @IBOutlet weak var saveImportButtonStack: UIStackView!
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var importFromHealthKitButtonOutlet: UIButton!
    // MARK: Weak Vars
    
    // MARK: Public Variables
    
    // MARK: Private Variables
    
    private var setName = "" {
        willSet {
            nameSet = true
        }
    }
    
    private var weightVaule = 0 {
        willSet {
            weightSet = true
        }
    }
    
    private var weightUnit = ""
    
    private var heightValue = "0" {
        willSet {
            heightSet = true
        }
    }
    private var heightInchValue = "0"
    private var setHeightString = ""
    
    private var genderVaule = "" {
        willSet {
            genderSet = true
        }
    }
    

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
    
    private var setBirthdate = Date() {
        willSet {
            birthdaySet = true
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButtonOutlet.layer.cornerRadius = saveButtonOutlet.frame.height / 3
        importFromHealthKitButtonOutlet.layer.cornerRadius = importFromHealthKitButtonOutlet.frame.height / 3
        
        pickerContainerView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        nameTextField.delegate = self
        
//        checkIfValuesExistAndSetLabels()
        
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
    
    @IBAction func importFromHealthKitButtonPressed(_ sender: UIButton) {
        let healthKitStore = HealthKitStore()
        healthKitStore.getUserDataFromHealthKit()
        
    }
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
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        getAndSaveData()
    }
    
    func showPickerViewFor(_ input: UserInputs) {
        textFieldWillEndEditing()
        pickerView.selectRow(0, inComponent: 0, animated: true)
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
        setBirthdate = sender.date
        birthdaySet = true
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
    
    // MARK: Saving Data
    
    func getAndSaveData() {
        let conversionator = UnitConversions()
        if weightSet && heightSet && genderSet && nameSet {
            if user.userDisplayUnits == .freedomUnits {
                //Convert weight to grams to store
                let weightInPounds = Double(weightVaule)
                let weightInGrams = conversionator.convertPoundsToKilograms(pounds: weightInPounds)
                user.weightInKilos = weightInGrams
                
                //Convert height to cm to store
                guard let heightFeet = Double(heightValue) else {return}
                guard let heightInches = Double(heightInchValue) else {return}
                let feetToInches = heightFeet * 12
                let totalInches = feetToInches + heightInches
                let inchesToCM = conversionator.convertInchesToCM(inches: totalInches)
                user.heightInMeters = inchesToCM
                
                //Convert date to string and save
                user.birthdate = setBirthdate
                
                //Save Name
                user.name = setName
                
                //Save gender
                user.gender = genderVaule
                
                print("Freedom units saved correctly!")
            } else {
                let weight = Double(weightVaule)
                user.weightInKilos = weight
                
                if let height = Double(heightValue) {
                    user.heightInMeters = height
                }
                
                user.birthdate = setBirthdate
                
                user.name = setName
                
                user.gender = genderVaule
                
                print("Saved metric units!")
            }
            let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Let's Go Hiking!", style: .default) { (buttonAction) in
                let saveButtonPressedDestination = "MainTabBar"
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // this assumes your storyboard is titled "Main.storyboard"
                let yourVC = mainStoryboard.instantiateViewController(withIdentifier: saveButtonPressedDestination) as! UITabBarController
                appDelegate.window?.rootViewController = yourVC
                appDelegate.window?.makeKeyAndVisible()
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            print(nameSet, birthdaySet, weightSet, heightSet, genderSet)
   
            let alert = UIAlertController(title: "Please finish entering all your information", message: "Hike Tracker uses this information to properly track your workout", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            //Present an alert saying which stat still needs to be set
            
        }
    }
    
    // MARK: Name Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldWillEndEditing()
        return true
    }
    
    func textFieldWillEndEditing() {
        nameTextField.resignFirstResponder()
        setName = nameTextField.text!
        nameTextField.placeholder = nameTextField.text
        nameSet = true
    }

    
    func checkIfValuesExistAndSetLabels() {
        let user = StoredUser()
        
        if let weightInKilos = user.getWeightForDisplay() {
            weightButtonOutlet.setTitle(weightInKilos, for: .normal)
        }
        if let userName = user.name {
            nameTextField.text = userName
        }
        
        if let gender = user.gender {
            sexButtonOutlet.setTitle(gender, for: .normal)
        }
        if let heightDisplayString = user.getHeightForDisplay() {
            heightButtonOutlet.setTitle(heightDisplayString, for: .normal)
        }
        if let birthdate = user.birthdate?.displayStringWithoutTime {
            birthdayButtonOutlet.setTitle(birthdate, for: .normal)
        }
        
        
    }
    
    func getInfoFromHealthKitAndSetValues(){
        
    }
    
    func saveSetUserInfo(){
        
    }
    func checkAllUserInfoIsEntered() {
        
    }
}



