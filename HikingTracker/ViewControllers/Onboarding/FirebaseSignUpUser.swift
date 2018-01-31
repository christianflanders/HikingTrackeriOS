//
//  FirebaseSignUpUser.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/31/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit
import Firebase


enum EmailEnteredOptions {
    case tryAgain
    case foundLogin
    case createPassword
    case userNotFound
}

enum CreateUserErrors {
    case weakPassword
    case networkError


}

struct FirebaseSignUpUser {

private let userCreationErrors = CreateUserErrors()


    func checkEmailWithFirebaseForExistingAccount(_ email: String, password: String) -> UIAlertController {
        if email != "" {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, firError) in
                if let firError = firError as NSError? {
                    guard let errorCode = AuthErrorCode(rawValue: firError.code) else { return }
                    switch errorCode {
                    case .userNotFound:
                        completion(.userNotFound)
                        print("user not found")
                    case .wrongPassword:
//                        self.presentUserFoundAlert()
                        completion(.foundLogin)
                    case .emailAlreadyInUse:
//                        self.presentUserFoundAlert()
                        completion(.foundLogin)
                        print("ExistingAccoutFoudn")
                    case .invalidEmail:
//                        self.invalidEmailAlert()
                        completion(.tryAgain)
                        print("emial is invalid")
                    case .networkError:
//                        self.networkError()
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
}
    //Not dealing with email errors here, those should have been handled already
    func signUpUser(email: String, password: String) -> Bool{
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let firError = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: firError.code) else {
                    fatalError("Problem with error code")
                }
                switch errorCode {
                case .weakPassword:

                case .networkError:
                    completion(.networkError)
                case .
                default:
                    print(errorCode.rawValue)
                }
            }

        }
    }

struct FirebaseAuthAlerts {


    // Email In Use case emailAlreadyInUse = 17007
    func emailInUserAlert(SignInAction: @escaping (UIAlertAction) ->(Void), NewAccountAction: @escaping (UIAlertAction)->(Void)) -> UIAlertController{
        let alert = UIAlertController(title: "Account found", message: "We found an account matching that email. Would you like to try to sign in, or create an account with a different email?", preferredStyle: .alert)
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: SignInAction)
        let createNewAccountAction = UIAlertAction(title: "Create new account", style: .default, handler: NewAccountAction)
        alert.addAction(signInAction)
        alert.addAction(createNewAccountAction)
        return alert
    }


    func weakPasswordAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Weak Password", message: "Your password must be 6 characters or more", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }

    func invalidEmailAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Problem with the email", message: "It looks like the email address you entered is invalid. Please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }

    func networkError() -> UIAlertController {
        let alert = UIAlertController(title: "Network Error", message: "There is a problem connecting to the network. Please try again later", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }

    func wrongPasswordAlert(tryAgainAction: @escaping (UIAlertAction) ->(Void), forgotPasswordAction: @escaping (UIAlertAction) ->(Void)) -> UIAlertController {
        let alert = UIAlertController(title: "Wrong password!", message: "Please try again", preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: tryAgainAction)
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .default, handler: forgotPasswordAction)
        alert.addAction(tryAgain)
        alert.addAction(forgotPasswordAction)
        return alert
    }

    func loginSuccessAlert(success: @escaping (UIAlertAction) ->(Void)) -> UIAlertController {
        let alert = UIAlertController(title: "Success!", message: "You're good to go. Let's go hiking!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's go", style: .default, handler: success)
        alert.addAction(action)
        return alert
    }
}
