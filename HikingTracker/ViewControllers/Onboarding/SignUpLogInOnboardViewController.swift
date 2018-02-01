//
//  SignUpLogInOnboardViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/28/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import Firebase

class SignUpLogInOnboardViewController: UIViewController{

    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var logInButtonOutlet: UIButton!

//    @IBOutlet weak var loginRightConst: NSLayoutConstraint!
//    @IBOutlet weak var loginButtonLeftConst: NSLayoutConstraint!
//
//    @IBOutlet weak var signUpButtonLeftConst: NSLayoutConstraint!
//    @IBOutlet weak var signUpButtonRightConst: NSLayoutConstraint!

    @IBOutlet weak var loginButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var firebaseLoginContainerView: UIView!

    @IBOutlet weak var compassImageView: UIImageView!

    @IBOutlet var openingLabels: [UILabel]!

    var shadowView: UIView!
    var constraintGoalValue: CGFloat!

    var enteredEmail = ""
    var enteredPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let constZeroValue = self.view.frame.width / 2

        setContainerViewAppearance()
        signUpButtonOutlet.layer.cornerRadius = self.signUpButtonOutlet.frame.height / 2
        logInButtonOutlet.layer.cornerRadius = self.logInButtonOutlet.frame.height / 2
        setupLoginButtonTextToFit()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateCompass()
        setContainerViewAppearance()
    }

    func setContainerViewAppearance() {
        firebaseLoginContainerView.layer.masksToBounds = false
        firebaseLoginContainerView.layer.cornerRadius = firebaseLoginContainerView.frame.height / 10
        firebaseLoginContainerView.clipsToBounds = true
        shadowView = UIView()
        shadowView.backgroundColor = UIColor.black
        shadowView.layer.opacity = 1.0
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.35
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.cornerRadius = firebaseLoginContainerView.bounds.size.width / 10
        shadowView.frame = CGRect(origin: CGPoint(x: firebaseLoginContainerView.frame.origin.x, y: firebaseLoginContainerView.frame.origin.y), size: CGSize(width: firebaseLoginContainerView.bounds.width, height: firebaseLoginContainerView.bounds.height))
        self.view.addSubview(shadowView)
        shadowView.isHidden = true
        view.bringSubview(toFront: firebaseLoginContainerView)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let firController = self.childViewControllers.first as! FirebaseSignUpViewController
        firController.shouldLogin = false
        firController.setUpForSignUp()
        firebaseLoginContainerView.isHidden = false
        signUpButtonOutlet.isHidden = true

        signUpButtonOutlet.isHidden = true
        logInButtonOutlet.isHidden = true
        for label in openingLabels {
            label.isHidden = true
        }

    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let firController = self.childViewControllers.first as! FirebaseSignUpViewController
        firController.shouldLogin = true
        firController.setUpForLogin()
        firebaseLoginContainerView.isHidden = false
        signUpButtonOutlet.isHidden = true
        logInButtonOutlet.isHidden = true
        for label in openingLabels {
            label.isHidden = true
        }

    }

    func setupLoginButtonTextToFit() { // Running into a problem with the label "fitting" but touching the edges of the button and looking weird
        logInButtonOutlet.titleLabel?.minimumScaleFactor = 0.3
        logInButtonOutlet.titleLabel?.numberOfLines = 1
        logInButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
        logInButtonOutlet.titleLabel?.adjustsFontForContentSizeCategory = true
        //        logInButtonOutlet.titleLabel?.preferredMaxLayoutWidth
        logInButtonOutlet.titleEdgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
        logInButtonOutlet.sizeToFit()
    }



    func animateCompass() {
        var compassImageArray = [UIImage]()
        DispatchQueue.global(qos: .userInitiated).async {
            for i in 0...84 {
                var stringNum = String(i)
                if i < 10 {
                    stringNum = "0\(stringNum)"
                }

                let stringName = "MovingCompassv.1_\(stringNum)"
                let newImage = UIImage(named: stringName)
                compassImageArray.append(newImage! )
            }
            DispatchQueue.main.async {
                self.compassImageView.animationImages = compassImageArray
                self.compassImageView.animationDuration = 2.0
                self.compassImageView.startAnimating()
            }
        }
    }





    
}

