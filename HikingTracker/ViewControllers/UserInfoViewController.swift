//
//  UserInfoViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import HealthKit


class UserInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //MARK: Enums
    
    //MARK: Constants
    let user = User()
    let saveButtonPressedDestination = "MainTabBar"
    let weightOptions = 0...600
    
    let lbsOrKilos = ["Pounds", "Kilograms"]

    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
 
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var setWeightButton: UIButton!
    //MARK: Weak Vars
    
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    private var name = ""
    private var weight: Double?
    private var height: Double?
    
    private var pickerWeight: Int?
    private var pickerWeightUnit = ""
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        
//        if let userWeight = user.weightInKilos {
//            weightTextField.text = String(userWeight)
//        } else {
//            weightTextField.text = "Please enter your weight"
//        }
        if let userHeight = user.heightInMeters {
            heightTextField.text = String(userHeight)
        } else {
            heightTextField.text = "Please enter your height"
        }
        if let userName = user.name {
            nameTextField.text = userName
        } else {
            nameTextField.text = "Please enter your name"
        }
    }
    

    //MARK: IBActions
    
    @IBAction func importFromHealthKitButtonPressed(_ sender: UIButton) {
    }
    

    @IBAction func setWeightButtonPressed(_ sender: UIButton) {
        pickerView.isHidden = !pickerView.isHidden
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //TODO: If all fields are not entered, display an error
        let defaults = UserDefaults.standard
        defaults.setValue(name, forKey: "name")
        defaults.setValue(weight, forKey: "weight")
        defaults.setValue(height, forKey: "height")
        //If coming from the tab bar, dismiss alert and continue. If coming from app delegate, open the main VC
        let alert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's Go Hiking!", style: .default) { (buttonAction) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // this assumes your storyboard is titled "Main.storyboard"
            let yourVC = mainStoryboard.instantiateViewController(withIdentifier: self.saveButtonPressedDestination) as! UITabBarController
            appDelegate.window?.rootViewController = yourVC
            appDelegate.window?.makeKeyAndVisible()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    //MARK: Instance Methods
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    

    //MARK: Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func nameTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text != nil || sender.text != "" {
            name = sender.text!
        }
        
    }

    
    @IBAction func heightTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text != nil || sender.text != "" {
            height = Double(sender.text!)
        }
    }
    
    
    //Mark: UIPickerView Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return weightOptions.count
        } else {
            return lbsOrKilos.count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(row)
        } else {
            return lbsOrKilos[row]
        }
    }
    
    
    
    //MARK: Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerWeight = row
        } else {
            pickerWeightUnit = lbsOrKilos[row]
        }
        
        setWeightButton.titleLabel?.text = "\(pickerWeight!) \(pickerWeightUnit)"

    }
    
    
}

