//
//  OnboardingFirstViewController.swift
//  Hike Tracker Onboard Screen
//
//  Created by Christian Flanders on 1/27/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class OnboardingFirstViewController: UIViewController {

    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var mountainImage: UIImageView!

    @IBOutlet weak var firstTextContainerView: UIView!
    @IBOutlet weak var secondTextContainerView: UIView!

    var grabCGRect: CGRect?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nextButtonOutlet.layer.cornerRadius = nextButtonOutlet.bounds.height / 2
        firstTextContainerView.alpha = 0.0
        secondTextContainerView.alpha = 0.0
        animateTextIn()
    }
    

    func animateTextIn()  {
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.firstTextContainerView.alpha = 1
        }
        UIView.animate(withDuration: 2.0, animations: {
            self.secondTextContainerView.alpha = 1
        })
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
           sender.titleLabel?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            sender.frame = self.view.frame
            sender.layer.cornerRadius = 0
            sender.titleLabel?.removeFromSuperview()
        }) { (finished) in
            if finished {
                self.performSegue(withIdentifier: "Next", sender: self)
            }
        }


//        sender.layer.cornerRadius = 0
//        sender.setTitle("", for: .normal)
    }
}
