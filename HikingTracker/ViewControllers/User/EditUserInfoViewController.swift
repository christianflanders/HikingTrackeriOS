//
//  UserViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController, UITextFieldDelegate {


    // MARK: Enums

    // MARK: Constants


    // MARK: Variables


    // MARK: Outlets
    @IBOutlet weak var userPickerVCContainer: UIView!

    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var importFromHealthKitButtonOutlet: UIButton!
    @IBOutlet weak var saveUserInfoButtonOutlet: UIButton!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var weightButtonOutlet: UIButton!
    @IBOutlet weak var heightButtonOutlet: UIButton!
    @IBOutlet weak var birthdateButtonOutlet: UIButton!
    @IBOutlet weak var genderButtonOutlet: UIButton!

    // MARK: Weak Vars


    // MARK: Public Variables


    // MARK: Private Variables


    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hidePickerVC()
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
        buttonStackView.isHidden = true
    }

    func showButtons() {
        buttonStackView.isHidden = false
    }

    func setCosmetics() {
        saveUserInfoButtonOutlet.layer.cornerRadius = saveUserInfoButtonOutlet.frame.height / 2
        importFromHealthKitButtonOutlet.layer.cornerRadius = importFromHealthKitButtonOutlet.frame.height / 2
    }


    func checkForExistingValuesAndSetLabels() {
        
    }



}



