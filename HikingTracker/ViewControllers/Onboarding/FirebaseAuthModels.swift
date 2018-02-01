//
//  FirebaseAuthAlerts.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/31/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//
import UIKit
import Foundation
import Firebase

enum EmailEnteredErrors {
    case tryAgain
    case foundLogin
    case createPassword
    case userNotFound
}



struct FirebaseCreateUser {

    func checkEmailExistsAndIsValid(email: String, results: @escaping (Bool, AuthErrorCode?) -> Void) {
        let fakePasswordToReturnCorrectError = " " //Firebase has no good way to check if a user already exists, so giving a space as a password will tell us if the user exists or not
        Auth.auth().signIn(withEmail: email, password: fakePasswordToReturnCorrectError, completion: { (user, error) in
            if let firError = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: firError.code) else { return }
                results(true, errorCode)
            } else { // No error and we can continue on safely
                results(true, nil)
            }
        })
    }


    func createUser(email:String, password: String, results: @escaping (Bool, AuthErrorCode?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let firError = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: firError.code) else { return }
                results(false, errorCode)
            } else { // No error and we can continue on safely
                results(true, nil)
            }
        }
    }


}


struct FirebaseLoginUser {

    func loginUser(email: String, password: String, results: @escaping (Bool, AuthErrorCode?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let firError = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: firError.code) else { return }
                results(false, errorCode)
            } else { // No error and we can continue on safely
                results(true, nil)
            }
        }
    }
}





