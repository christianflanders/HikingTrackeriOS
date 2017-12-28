//
//  UserViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Enums
    
    // MARK: Constants
    private let userOptions = ["Name", "Gender", "Birthdate", "Weight"]
    
    // MARK: Variables
    
    // MARK: Outlets

    @IBOutlet weak var userInfoTableView: UITableView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerContainerView: UIView!
    
    // MARK: Weak Vars
    
    // MARK: Public Variables

    // MARK: Private Variables

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        pickerContainerView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self 
        
    }

    // MARK: IBActions
    
    @IBAction func pickerDoneButtonPressed(_ sender: UIButton) {
        
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "User Stat Cell", for: indexPath) as? UserStatTableViewCell else {fatalError("Problem with tableView cells")}
        cell.userStatDescriptionLabel.text = userOptions[indexPath.row]
        return cell
        
    }
    
        // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If the name cell is selected, pop up an alert that allows us to type it in.
        if indexPath.row == 0 {
            
            //Else, display the picker view to set the information
        } else {
            pickerContainerView.isHidden = !pickerContainerView.isHidden
        }
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    // MARK: UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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

}
