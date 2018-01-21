//
//  ShowUserInfoViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/29/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI


class ShowUserInfoViewController: UIViewController, FUIAuthDelegate {
    
    // MARK: Enums
    
    // MARK: Constants
    private let user = StoredUser()
    
    // MARK: Variables
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    // MARK: Weak Vars
    
    // MARK: Public Variables
    
    // MARK: Private Variables
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        updateUserStatsDisplay()
    }
    
    
    // MARK: IBActions
    
//    @IBAction func logOutBarButtonPressed(_ sender: UIBarButtonItem) {
//        do {
//            try Auth.auth().signOut()
//            checkUserAuthAndPresentCorrectInformation()
//        } catch {
//            print("Problem signing out!")
//        }
//
//    }
//
    func updateUserStatsDisplay() {
//        nameLabel.text = user.name
//        weightLabel.text = user.getWeightForDisplay()
//        heightLabel.text = user.getHeightForDisplay()
//        sexLabel.text = user.gender
//        birthdateLabel.text = user.birthdate?.displayStringWithoutTime
    }
    
    func checkUserAuthAndPresentCorrectInformation(){
//        if let currentUser = Auth.auth().currentUser {
//            currentUser.getIDTokenForcingRefresh(true, completion: { (_, error) in
//                if error != nil {
//                    print("User deleted")
//                    let authUI = FUIAuth.defaultAuthUI()
//                    let authUIView = authUI?.authViewController()
//                    authUI?.delegate = self
//                    self.present(authUIView!, animated: true, completion: nil)
//                } else {
//                    print("User found go ahead")
//                }
//            })
//        } else {
//            print("log in")
//            let authUI = FUIAuth.defaultAuthUI()
//            let authUIView = authUI?.authViewController()
//            authUI?.delegate = self
//            present(authUIView!, animated: true, completion: nil)
//        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Show User Info Segue" {
//            if let navCont = segue.destination as? UINavigationController {
//                let destinationVC = navCont.topViewController as! EditUserInfoViewController
//                destinationVC.comingFromShowUserScreen = true
            }
}

