//
//  UserSettingsOnboardingContainerViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/28/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class UserSettingsOnboardingContainerViewController: UIViewController, UserSettingsSaved {



    override func viewDidLoad() {
        super.viewDidLoad()
        let childUserVC = self.childViewControllers.first as! EditUserInfoViewController
        childUserVC.userSettingsSavedDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }

    func userSettingsSaved() {
//        let childUserVC = self.childViewControllers.first as! EditUserInfoViewController
//        childUserVC.dismiss(animated: true, completion: nil)

        performSegue(withIdentifier: "OnboardingSettingsSaved", sender: self)
//        let childUserVC = self.childViewControllers.first as! EditUserInfoViewController
//        childUserVC.userSettingsSavedDelegate = nil
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
