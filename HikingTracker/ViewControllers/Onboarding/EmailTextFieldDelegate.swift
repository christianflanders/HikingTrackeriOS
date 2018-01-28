//
//  EmailTextFieldDelegate.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/28/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

class EmailTextFieldDelegate: NSObject, UITextFieldDelegate {


    var emailEnteredDelegate: EmailTextFieldEntered!

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Hit Return")
        emailEnteredDelegate.emailTextFieldEntered()

        return true
    }

}
