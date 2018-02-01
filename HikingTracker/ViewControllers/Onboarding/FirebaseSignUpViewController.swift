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


    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var passwordStack: UIStackView!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    var storedEmail = ""
//    var storedPassword = " "

    let firCreateUser = FirebaseCreateUser()

    let emailTextFieldDelegate = EmailTextFieldDelegate()
    let passwordTextFieldDelegate = PasswordTextField()


    var accountFound = false

    var shouldLogin = false {
        willSet {
            if newValue {
                setUpForLogin()
            } else {
                setUpForSignUp()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordStack.alpha = 0
        emailTextField.delegate = emailTextFieldDelegate
        emailTextFieldDelegate.emailEnteredDelegate = self
        passwordTextField.delegate = passwordTextFieldDelegate
        passwordTextFieldDelegate.passwordEnteredDelegate = self

        passwordTextField.isSecureTextEntry = true
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        let parentVC = self.parent as! SignUpLogInOnboardViewController
        parentVC.childDismissed()
    }

    func setUpForLogin() {
        showPasswordField()
        titleLabel.text = "Log In"
    }

    func setUpForSignUp() {
        titleLabel.text = "Sign Up"
    }


    private func showPasswordField() {
        UIView.animate(withDuration: 0.2) {
            self.passwordStack.alpha = 1
        }
    }

    private func clearPasswordField() {
        passwordTextField.text = nil
    }

    private func clearEmailField() {
        emailTextField.text = nil
    }

    private let firAuthCreateUser = FirebaseCreateUser()
    private let alerts = FirebaseAuthAlerts()
    private let firAuthSignInUser = FirebaseLoginUser()




    func emailFieldReturned() {
        if shouldLogin {

        } else {
            firAuthCreateUser.checkEmailExistsAndIsValid(email: emailTextField.text!) { (success, errorCode) in

                if errorCode == nil {
                    self.showPasswordField()
                } else {
                    self.checkErrorCodeAndDisplayAlert(errorCode!)
                }
            }

        }

    }

    func passwordFieldReturned() {
        guard let email = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        if shouldLogin {
            firAuthSignInUser.loginUser(email: email, password: passwordText, results: { (success, errorCode) in
                if errorCode != nil {
                    self.checkErrorCodeAndDisplayAlert(errorCode!)
                }
                if success {
                    self.successLetsGoAlert()
                }
            })
        } else {
            firAuthCreateUser.createUser(email: email, password: passwordText, results: { (success, errorCode) in
                if errorCode != nil {
                    self.checkErrorCodeAndDisplayAlert(errorCode!)
                }
                if success {
                    self.successLetsGoAlert()
                }
            })
        }

    }

    private func checkErrorCodeAndDisplayAlert(_ errorCode: AuthErrorCode) {
        switch errorCode {
        case .emailAlreadyInUse:
            emailInUseAlert()
        case .weakPassword:
            weakPasswordAlert()
        case .invalidEmail:
            invalidEmailAlert()
        case .networkError:
            networkErrorAlert()
        case .wrongPassword:
            wrongPasswordAlert()
        case .userNotFound:
            userNotFoundAlert()
        default:
            print(errorCode.rawValue)
        }
    }

    private func userNotFoundAlert() {
        if shouldLogin {
            let alert = UIAlertController(title: "No Account Found", message: "No account was found for that email. Either re-enter your email, or create a new account", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                self.clearPasswordField()
                self.clearEmailField()
            })
            let newAccountOption = UIAlertAction(title: "Create Account", style: .default, handler: { (action) in
                self.shouldLogin = false
                self.emailFieldReturned()
            })
            alert.addAction(tryAgainAction)
            alert.addAction(newAccountOption)
            self.present(alert, animated: true, completion: nil)
        } else {
            showPasswordField()
        }
    }

    private func wrongPasswordAlert() {
        if shouldLogin {
            let alert = alerts.wrongPasswordAlert(tryAgainAction: { (_) -> (Void) in
                self.clearPasswordField()
            }) { (resetPassword) in
                self.sendResetEmail()
                self.clearPasswordField()
            }
            self.present(alert, animated: true, completion: nil)
        } else {
            emailInUseAlert()
        }

    }

    private func sendResetEmail() {

    }

    private func networkErrorAlert() {
        let alert = alerts.networkError()
        self.present(alert, animated: true, completion: nil)
    }

    private func emailInUseAlert() {
        let alert = alerts.emailInUseAlert()
        self.present(alert, animated: true) {
            self.shouldLogin = true
            self.showPasswordField()
        }

}

    private func weakPasswordAlert() {
        if shouldLogin {
            let alert = alerts.weakPasswordAlert()
            self.present(alert, animated: true) {
                self.clearPasswordField()
            }
        } else {
            self.showPasswordField()
        }

    }


    func emailTextFieldEntered() {
        emailFieldReturned()

    }

    func passswordTextFieldEntered() {
        passwordFieldReturned()
    }
    // MARK: Sign Up Methods


    

    func presentUserFoundAlert() {
        let alert = UIAlertController(title: "Existing user found", message: "It looks like there is an existing user for that email address. Log in with your password instead", preferredStyle: .alert)
        let action = UIAlertAction(title: "Log In", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func invalidEmailAlert() {
        if shouldLogin {
            let alert = UIAlertController(title: "No Account Found", message: "No account was found for that email. Either re-enter your email, or create a new account", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                self.clearPasswordField()
                self.clearEmailField()
            })
            let newAccountOption = UIAlertAction(title: "Create Account", style: .default, handler: { (action) in
                self.shouldLogin = false
                self.emailFieldReturned()
            })
            alert.addAction(tryAgainAction)
            alert.addAction(newAccountOption)
            self.present(alert, animated: true, completion: nil)
        }
        let alert = alerts.invalidEmailAlert()
        self.present(alert, animated: true) {
            self.clearPasswordField()
            self.clearEmailField()
        }
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
