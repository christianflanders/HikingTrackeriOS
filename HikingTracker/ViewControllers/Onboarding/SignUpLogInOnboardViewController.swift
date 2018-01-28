//
//  SignUpLogInOnboardViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/28/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class SignUpLogInOnboardViewController: UIViewController {

    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var logInButtonOutlet: UIButton!

    @IBOutlet weak var loginRightConst: NSLayoutConstraint!
    @IBOutlet weak var loginButtonLeftConst: NSLayoutConstraint!

    @IBOutlet weak var signUpButtonLeftConst: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonRightConst: NSLayoutConstraint!


    var constraintGoalValue: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        let constZeroValue = self.view.frame.width / 2
        constraintGoalValue = loginRightConst.constant
        setLoginConstraints(to: constZeroValue)
        setSignUpConstraints(to: constZeroValue)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateButtons()
    }

    


    func animateButtons() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.signUpButtonLeftConst.constant = self.constraintGoalValue
            self.signUpButtonRightConst.constant = self.constraintGoalValue
            self.signUpButtonOutlet.layer.cornerRadius = self.signUpButtonOutlet.frame.height / 2
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseInOut, animations: {
            self.loginRightConst.constant = self.constraintGoalValue
            self.loginButtonLeftConst.constant = self.constraintGoalValue
            self.logInButtonOutlet.layer.cornerRadius = self.logInButtonOutlet.frame.height / 2
            self.view.layoutIfNeeded()


        }, completion: nil)
    }

    func setLoginConstraints(to num: CGFloat) {
        loginRightConst.constant = num
        loginButtonLeftConst.constant = num
        self.view.layoutIfNeeded()
    }

    func setSignUpConstraints(to num: CGFloat) {
        signUpButtonLeftConst.constant = num
        signUpButtonRightConst.constant = num
        self.view.layoutIfNeeded()
    }
}
