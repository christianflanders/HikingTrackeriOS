//
//  SecondOnboardingViewController.swift
//  Hike Tracker Onboard Screen
//
//  Created by Christian Flanders on 1/27/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class SecondOnboardingViewController: UIViewController {

    @IBOutlet weak var secondLabelCenter: NSLayoutConstraint!
    @IBOutlet weak var firstLabelCenter: NSLayoutConstraint!



    @IBOutlet weak var gotItButton: UIButton!

    let valueToSpringOver: CGFloat = 50.0

    let timeToSpringBack = 0.2
    override func viewDidLoad() {
        super.viewDidLoad()
        secondLabelCenter.constant -= view.bounds.width
        firstLabelCenter.constant -= view.bounds.width
        gotItButton.layer.cornerRadius = gotItButton.frame.height / 2

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        animateInLabels()
    }
    


    


    func animateInLabels() {

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.firstLabelCenter.constant += self.view.bounds.width + self.valueToSpringOver
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            if completed {
                self.animateFirstLabelIntoPlace()
            }
        } )
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseInOut, animations: {
            self.secondLabelCenter.constant += self.view.bounds.width + self.valueToSpringOver
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            if completed {
                self.animateSecondLabelIntoPlace()
            }
        })

    }



    func animateFirstLabelIntoPlace() {
        UIView.animate(withDuration: timeToSpringBack, delay: 0, options: .curveEaseInOut, animations: {
            self.firstLabelCenter.constant -= self.valueToSpringOver
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animateSecondLabelIntoPlace() {
        UIView.animate(withDuration: timeToSpringBack, delay: 0, options: .curveEaseInOut, animations: {
            self.secondLabelCenter.constant -= self.valueToSpringOver
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
