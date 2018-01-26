//
//  UserViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController, UITextFieldDelegate, HeightPickerValueSelectedDelegate , WeightPickerValueSelectedDelegate, GenderPickerValueSelectedDelegate, BirthdateSelectedDelegate {







    // MARK: Enums

    // MARK: Constants


    // MARK: Variables
    var userSettingValues = UserInformationValues()

    // MARK: Outlets
    @IBOutlet weak var userPickerVCContainer: UIView!

    @IBOutlet weak var importFromHealthKitButtonOutlet: UIButton!
    @IBOutlet weak var saveUserInfoButtonOutlet: UIButton!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var weightButtonOutlet: UIButton!
    @IBOutlet weak var heightButtonOutlet: UIButton!
    @IBOutlet weak var birthdateButtonOutlet: UIButton!
    @IBOutlet weak var genderButtonOutlet: UIButton!

    // MARK: Weak Vars


    // MARK: Public Variables
    var heightValueSetDelegate: HeightPickerValueSelectedDelegate?

    // MARK: Private Variables


    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hidePickerVC()
        setCosmetics()

        userNameTextField.delegate = self

        let pickerController = self.childViewControllers.first as! UserInfoPickerViewController
        let heightDataSource = pickerController.heightPickerViewDataSource
        heightDataSource.heightValueSetDelegate = self

        let weightDataSource = pickerController.weightPickerViewDataSource
        weightDataSource.weightValueSetDelegate = self


        let genderDataSource = pickerController.genderPickerViewDataSource
        genderDataSource.genderSelectedDelegate = self

        pickerController.birthDateSelectedDelegate = self

        self.tabBarController?.tabBar.isHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkForExistingValuesAndSetLabels()
        setCosmetics()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: IBActions


    @IBAction func saveUserInfoButtonPressed(_ sender: UIButton) {
        prepareToSave()
    }

    @IBAction func weightButtonPressed(_ sender: UIButton) {
        showPickerVCWithOption(.weight)
    }

    @IBAction func heightButtonPressed(_ sender: UIButton) {
        showPickerVCWithOption(.height)
    }

    @IBAction func birthdateButtonPressed(_ sender: UIButton) {
        showPickerVCWithOption(.birthdate)
    }


    @IBAction func genderButtonPressed(_ sender: UIButton) {
        showPickerVCWithOption(.gender)
    }
    public func hidePickerVC() {
        userPickerVCContainer.isHidden = true
        showButtons()
    }

    func showPickerVCWithOption(_ option: StoredUserOptions ) {
        hideButtons()
        userPickerVCContainer.isHidden = false
        let pickerVC = self.childViewControllers.last as! UserInfoPickerViewController
        pickerVC.whichPickerToDisplay = option
        pickerVC.checkWhichPickerToDisplay()
    }

    func hideButtons() {
    }

    func showButtons() {
    }

    func setCosmetics() {
        saveUserInfoButtonOutlet.layer.cornerRadius = saveUserInfoButtonOutlet.frame.size.height / 2
        importFromHealthKitButtonOutlet.layer.cornerRadius = importFromHealthKitButtonOutlet.frame.size.height / 2

        birthdateButtonOutlet.titleLabel?.minimumScaleFactor = 0.75
    }


    func checkForExistingValuesAndSetLabels() {
        let user = StoredUser()
        if let setBirthdate = user.birthdate {
            userSettingValues.birthdate = setBirthdate
        }
        if let setHeight = user.heightInCentimeters {
            userSettingValues.heightInCentimeters = setHeight
        }
        if let setWeight = user.weightInKilos {
            userSettingValues.weightInKG = setWeight
        }
        if let setName = user.name {
            userSettingValues.name = setName
        }
        if let setGender = user.gender {
            userSettingValues.gender = setGender
        }
        setLablesBasedOnValues()

    }


    // MARK: Height Picker Value Set

    func heightValueSet(stringValue: String, heightInCM: Double) {
        heightButtonOutlet.setTitle(stringValue, for: .normal)
        userSettingValues.heightInCentimeters = heightInCM
    }

    // MARK: Weight picker value set delegate

    func weightValueSet(stringValue: String, weightInKG: Double) {
        weightButtonOutlet.setTitle(stringValue, for: .normal)
        userSettingValues.weightInKG = weightInKG
    }

    // MARK: Gender pickerview value set delegate

    func valueSet(gender: String) {
        genderButtonOutlet.setTitle(gender, for: .normal)
        userSettingValues.gender = gender
    }

    // MARK: Birthdate Value Set Delegate Method
    func valueSet(birthdate: Date) {
        let dateConvertedToString = birthdate.displayStringWithoutTimeShorter
        birthdateButtonOutlet.setTitle(dateConvertedToString, for: .normal)
        userSettingValues.birthdate = birthdate
    }



    //MARK: Name Text Field

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != "" || textField.text != " " {
            userSettingValues.name = textField.text
        }
        return true
    }




    func checkAllValuesSet(for userValues: UserInformationValues) -> Bool {
        var allValuesSet = false
        if userValues.allValuesSet {
            allValuesSet = true
        } else {
            allValuesSet = false
        }
        return allValuesSet
    }


    //MARK: Saving User

    func prepareToSave() {
        let storedUser = StoredUser()
        if checkAllValuesSet(for: userSettingValues) {
            storedUser.birthdate = userSettingValues.birthdate
            storedUser.gender = userSettingValues.gender
            storedUser.heightInCentimeters = userSettingValues.heightInCentimeters
            storedUser.name = userSettingValues.name
            storedUser.weightInKilos = userSettingValues.weightInKG
            showLetsGoHikingAlert()
            goToMainScreen()
        } else {
            showNotAllValuesSetAlert()
        }
    }

    func showNotAllValuesSetAlert() {
        let alert = UIAlertController(title: "Error!", message: "Not all values are entered correctly", preferredStyle: .alert)
        let action = UIAlertAction(title: "Please recheck the information and try again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func showLetsGoHikingAlert() {
        let alert = UIAlertController(title: "Information Saved", message: "Let's Go Hiking!", preferredStyle: .alert)
        let action = UIAlertAction(title: "👍", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


    func goToMainScreen() {
        let saveButtonPressedDestination = "MainTabBar"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // this assumes your storyboard is titled "Main.storyboard"
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: saveButtonPressedDestination) as! UITabBarController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
    }





    // MARK: Import From Healthkit





    fileprivate func setLablesBasedOnValues() {
        let conv = UnitConversions()
        let displayUnits = StoredUser().userDisplayUnits
        if let name = self.userSettingValues.name {
            self.userNameTextField.text = name
        }


        if displayUnits == .freedomUnits {
            self.convertCMToFeetAndInchesAndSetTitle(conv)
            self.convertKGToPoundsAndSetTitle(conv)
        } else {
            self.checkForCMAndSetTitle()
            self.checkForKGAndSetTitle()
        }
        self.checkForBirthdateAndSetTitle()
        self.checkForGenderAndSetTitle()
    }

    fileprivate func checkHealthKitAndSetFoundValues() {
        let healthKitStore = HealthKitStore()
        let dataFromHealthKit = healthKitStore.getUserDataFromHealthKit()
        userSettingValues = dataFromHealthKit
        DispatchQueue.main.async {
            self.setLablesBasedOnValues()

        }

    }

    @IBAction func importFromHealthKitButtonPressed(_ sender: UIButton) {
        HealthKitAuthroizationSetup.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                print("Health Kit Authorization failed!")
                return
            }
            self.checkHealthKitAndSetFoundValues()
            print("HealthKit successfully authorized")
        }

        checkHealthKitAndSetFoundValues()
    }


    fileprivate func checkForGenderAndSetTitle() {
        if let gender = userSettingValues.gender {
            genderButtonOutlet.setTitle(gender, for: .normal)
        }
    }

    fileprivate func checkForBirthdateAndSetTitle() {
        if let birthdate = userSettingValues.birthdate {
            let stringVersion = birthdate.displayStringWithoutTimeShorter
            birthdateButtonOutlet.setTitle(stringVersion, for: .normal)
        }
    }

    fileprivate func convertCMToFeetAndInchesAndSetTitle(_ conv: UnitConversions) {
        if let heightInCM = userSettingValues.heightInCentimeters {
            let convertedToInches = conv.convertCMToInches(cm: heightInCM)
            let feetToDisplay = Int(convertedToInches / 12)
            let inchesToDisplay = Int(convertedToInches) % 12
            let displayString = "\(feetToDisplay) ft \(inchesToDisplay) in"
            heightButtonOutlet.setTitle(displayString, for: .normal)
        }
    }

    fileprivate func convertKGToPoundsAndSetTitle(_ conv: UnitConversions) {
        if let weightInKG = userSettingValues.weightInKG {
            let weightInPounds = conv.convertKilogramsToPounds(grams: weightInKG)
            let displayString = "\(Int(weightInPounds)) lbs"
            weightButtonOutlet.setTitle(displayString, for: .normal)
        }
    }


    fileprivate func checkForCMAndSetTitle() {
        if let heightInCM = userSettingValues.heightInCentimeters {
            let displayString = "\(Int(heightInCM)) cm"
            heightButtonOutlet.setTitle(displayString, for: .normal)
        }
    }

    fileprivate func checkForKGAndSetTitle() {
        if let weightInKG = userSettingValues.weightInKG {
            let displayString = "\(Int(weightInKG)) kg"
            weightButtonOutlet.setTitle(displayString, for: .normal)
        }
    }




}





