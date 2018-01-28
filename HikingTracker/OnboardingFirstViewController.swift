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


    var grabCGRect: CGRect?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nextButtonOutlet.layer.cornerRadius = nextButtonOutlet.bounds.height / 2
    }
    

    func animateMountainLogo()  {
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.mountainImage.frame = (self?.grabCGRect!)!
            self?.view.layoutIfNeeded()

        }
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
           sender.titleLabel?.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
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
