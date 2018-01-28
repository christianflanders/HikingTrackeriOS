//
//  FirebaseSignUpViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/27/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

protocol EmailTextFieldEntered {
    func emailTextFieldEntered()
}

class FirebaseSignUpViewController: UIViewController , EmailTextFieldEntered {

    @IBOutlet weak var passwordStack: UIStackView!

    @IBOutlet weak var emailTextField: UITextField!


    let emailTextFieldDelegate = EmailTextFieldDelegate()

    var accountFound = false

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordStack.alpha = 0
        emailTextField.delegate = emailTextFieldDelegate
        emailTextFieldDelegate.emailEnteredDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func revealPasswordStack() {

    }


    func emailTextFieldEntered() {
        if accountFound {
            displayLoginAlert()
        }
        UIView.animate(withDuration: 1.0) {
            self.passwordStack.alpha = 1
        }
    }


    func displayLoginAlert() {
        let alert = UIAlertController(title: "Account with that email found", message: "Please login with your password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
