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



enum CreateUserErrors {
    case weakPassword
    case networkError


}


struct FirebaseAuthAlerts {


    // Email In Use case emailAlreadyInUse = 17007
    func emailInUseAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Account found", message: "Try logging in instead", preferredStyle: .alert)
        let signInAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(signInAction)
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
        let alert = UIAlertController(title: "Network Error", message: "There is a problem connecting to the network. Please check your connection or try again later", preferredStyle: .alert)
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
