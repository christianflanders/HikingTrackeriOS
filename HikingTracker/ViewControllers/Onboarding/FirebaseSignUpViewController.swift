//
//  FirebaseSignUpViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/27/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import Firebase

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



    // MARK: Sign Up Methods


    func emailTextFieldEntered() {
        let email = emailTextField.text
        let passwordThatWillThrowTheCorrectError = " "
        checkEmailWithFirebaseForExistingAccount(email!, password: passwordThatWillThrowTheCorrectError) { (option) in
            switch option {
            case .tryAgain:
                self.clearField()
            case .createPassword:
                self.storeEmailAndPresentPassword()
            case .foundLogin:
                self.logInInstead()
            }
        }
    }

    func showPasswordField() {
        UIView.animate(withDuration: 1.0) {
            self.passwordStack.alpha = 1
        }
    }

    func logInInstead() {
        showPasswordField()


    }
    func storeEmailAndPresentPassword() {
        showPasswordField()

    }

    func clearField() {
        emailTextField.text = nil
        emailTextField.placeholder = "Enter Email"
    }

    enum EmailEnteredOptions {
        case tryAgain
        case foundLogin
        case createPassword

    }

    func displayLoginAlert() {
        let alert = UIAlertController(title: "Account with that email found", message: "Please login with your password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func checkEmailWithFirebaseForExistingAccount(_ email: String, password: String, completion: @escaping (EmailEnteredOptions) -> Void) {
        if email != "" {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, firError) in
                if let firError = firError as NSError? {
                    guard let errorCode = AuthErrorCode(rawValue: firError.code) else { return }
                    switch errorCode {
                    case .userNotFound:
                        print("user not found")
                    case .emailAlreadyInUse:
                        self.presentUserFoundAlert()
                        completion(.foundLogin)
                        print("ExistingAccoutFoudn")
                    case .invalidEmail:
                        self.invalidEmailAlert()
                        completion(.tryAgain)
                        print("emial is invalid")
                    case .networkError:
                        self.networkError()
                        completion(.tryAgain)
                        print("networkProblem")
                    default:
                        print(errorCode.rawValue)
                    }
                } else { // No error and we can continue on safely
                    completion(.createPassword)
                }
            })
        }
    }


    func presentUserFoundAlert() {
        let alert = UIAlertController(title: "Existing user found", message: "It looks like there is an existing user for that email address. Log in with your password instead", preferredStyle: .alert)
        let action = UIAlertAction(title: "Log In", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func invalidEmailAlert() {
        let alert = UIAlertController(title: "Problem with the email", message: "It looks like the email address you entered is invalid. Please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func networkError() {
        let alert = UIAlertController(title: "Network Error", message: "There is a problem connecting to the network. Please try again later", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }







}
