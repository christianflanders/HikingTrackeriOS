//
//  SettingsViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var unitsSegControl: UISegmentedControl!
    
    let user = StoredUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        switch user.userDisplayUnits {
        case .freedomUnits :
            unitsSegControl.isEnabledForSegment(at: 0)
        case .metric :
            unitsSegControl.isEnabledForSegment(at: 1)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unitsSegControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            user.userDisplayUnits = .freedomUnits
        case 1:
            user.userDisplayUnits = .metric
        default:
            print("This segmented control should only have 2 options how did we get here??")
        }
    }
    

}
