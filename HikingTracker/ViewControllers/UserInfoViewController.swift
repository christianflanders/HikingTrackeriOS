//
//  UserInfoViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import HealthKit


class UserInfoViewController: UIViewController, UITextFieldDelegate{

    
    //MARK: Enums
    
    //MARK: Constants
    let user = User()

    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    //MARK: Weak Vars
    
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    private var name = ""
    private var weight: Double?
    private var height: Double?
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userWeight = user.weightInKilos {
            weightTextField.text = String(userWeight)
        } else {
            weightTextField.text = "Please enter your weight"
        }
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
        // Do any additional setup after loading the view.
    }
    

    //MARK: IBActions
    
    @IBAction func importFromHealthKitButtonPressed(_ sender: UIButton) {
   
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //TODO: If all fields are not entered, display an error
        let defaults = UserDefaults.standard
        defaults.setValue(name, forKey: "name")
        defaults.setValue(weight, forKey: "weight")
        defaults.setValue(height, forKey: "height")
        presentAlert(title: "Saved!", message: "Success1", view: self)
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
    @IBAction func weightTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text != nil || sender.text != "" {
            
            weight = Double(sender.text!)
        }
        
    }
    
    @IBAction func heightTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text != nil || sender.text != "" {
            height = Double(sender.text!)
        }
    }
    
    
    
    
}

