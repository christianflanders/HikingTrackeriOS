//
//  PasswordTextField.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/29/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

class PasswordTextField: NSObject, UITextFieldDelegate {


    var passwordEnteredDelegate: PasswordTextFieldEntered!

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Hit Return")
        passwordEnteredDelegate.passswordTextFieldEntered()

        return true
    }

}
