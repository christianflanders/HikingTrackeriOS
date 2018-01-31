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

protocol PasswordTextFieldEntered {
    func passswordTextFieldEntered()
}

class FirebaseSignUpViewController: UIViewController , EmailTextFieldEntered, PasswordTextFieldEntered {

    @IBOutlet weak var passwordStack: UIStackView!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    var storedEmail = ""
//    var storedPassword = " "

    let emailTextFieldDelegate = EmailTextFieldDelegate()
    let passwordTextFieldDelegate = PasswordTextField()


    var accountFound = false

    var shouldLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordStack.alpha = 0
        emailTextField.delegate = emailTextFieldDelegate
        emailTextFieldDelegate.emailEnteredDelegate = self
        passwordTextField.delegate = passwordTextFieldDelegate
        passwordTextFieldDelegate.passwordEnteredDelegate = self

        passwordTextField.isSecureTextEntry = true



    }



    // MARK: Sign Up Methods


    func emailTextFieldEntered() {
        guard let email = emailTextField.text else {
            invalidEmailAlert()
            return
        }
        let passwordThatWillThrowTheCorrectError = " "
        checkEmailWithFirebaseForExistingAccount(email, password: passwordThatWillThrowTheCorrectError) { (option) in
            switch option {
            case .tryAgain:
                self.clearField()
            case .createPassword:
                self.storeEmailAndPresentPassword(email: email)
            case .foundLogin:
                self.logInInstead()
            case .userNotFound:
                self.storeEmailAndPresentPassword(email: email)
            }
        }
    }

    func passswordTextFieldEntered() {
        guard let storedPassword = passwordTextField.text else { return }
        if shouldLogin {
            tryToLoginUser(email: storedEmail, password: storedPassword, completion: { (option) in
                switch option {
                default:
                    print("Problem")
                }
            })
        } else {
            Auth.auth().createUser(withEmail: storedEmail, password: storedPassword) { (user, error) in
                if let firError = error as NSError? {
                    guard let errorCode = AuthErrorCode(rawValue: firError.code) else { return }
                    switch errorCode {
                    case .weakPassword:
                        self.weakPasswordAlert()
                    default:
                        print(errorCode.rawValue)
                    }
                } else {
                    self.successLetsGoAlert()

                }
        }

    }
    }

    func weakPasswordAlert() {
        let alert = UIAlertController(title: "Weak Password", message: "Your password must be 6 characters or more", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true) {
            self.passwordTextField.text = nil

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
    func storeEmailAndPresentPassword(email: String) {
        storedEmail = email
        showPasswordField()
    }

    func clearField() {
        emailTextField.text = nil
        emailTextField.placeholder = "Enter Email"
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
                        completion(.userNotFound)
                        print("user not found")
                    case .wrongPassword:
                        self.presentUserFoundAlert()
                        completion(.foundLogin)
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

    func successLetsGoAlert() {
        let alert = UIAlertController(title: "Success!", message: "You're good to go. Let's go hiking!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's Go", style: .default) { (action) in
//            let fireBaseView = self.childViewControllers.first
//            fireBaseView?.dismiss(animated: true, completion: nil)
            let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
            self.present(mainView, animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true)

    }







}
