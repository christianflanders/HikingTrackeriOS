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

    }


    // MARK: IBActions

    @IBAction func importFromHealthKitButtonPressed(_ sender: UIButton) {
    }

    @IBAction func saveUserInfoButtonPressed(_ sender: UIButton) {
    }

    @IBAction func weightButtonPressed(_ sender: UIButton) {
    }

    @IBAction func heightButtonPressed(_ sender: UIButton) {
    }

    @IBAction func birthdateButtonPressed(_ sender: UIButton) {
    }

    @IBOutlet weak var genderButtonPressed: UIButton!
    
    public func hidePickerVC() {
        userPickerVCContainer.isHidden = true
    }

    func showPickerVCWithOption() {
        userPickerVCContainer.isHidden = false
    }




    

}



