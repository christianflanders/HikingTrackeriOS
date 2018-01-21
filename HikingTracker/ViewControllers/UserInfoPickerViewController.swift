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

    // MARK: Variables


    // MARK: Outlets

    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var birthDatePickerView: UIDatePicker!


    // MARK: Weak Vars


    // MARK: Public Variables
//    var loadMetricOrImperial: DisplayUnits!

    // MARK: Private Variables


    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: IBActions

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let parentVC = self.parent as! EditUserInfoViewController
        parentVC.hidePickerVC()
    }


    // MARK: PickerView Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
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





}
