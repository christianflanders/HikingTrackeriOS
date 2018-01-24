//
//  UserViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController, UITextFieldDelegate, HeightPickerValueSelectedDelegate , WeightPickerValueSelectedDelegate {




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

        let pickerController = self.childViewControllers.first as! UserInfoPickerViewController
        let heightDataSource = pickerController.heightPickerViewDataSource
        heightDataSource.heightValueSetDelegate = self

        let weightDataSource = pickerController.weightPickerViewDataSource
        weightDataSource.weightValueSetDelegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setCosmetics()
    }

    // MARK: IBActions

    @IBAction func importFromHealthKitButtonPressed(_ sender: UIButton) {

    }

    @IBAction func saveUserInfoButtonPressed(_ sender: UIButton) {
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
    }


    func checkForExistingValuesAndSetLabels() {
        
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





    func checkAllValuesSet(for userValues: UserInformationValues) -> Bool {
        var allValuesSet = false
        if userValues.allValuesSet {
            allValuesSet = true
        } else {
            allValuesSet = false
        }
        return allValuesSet
    }
}



