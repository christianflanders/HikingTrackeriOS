//
//  SettingsTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/13/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: Enums

    // MARK: Constants
    let user = StoredUser()

    // MARK: Variables


    // MARK: Outlets
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!

    @IBOutlet weak var pauseSoundSwitchOutlet: UISwitch!
    @IBOutlet weak var resetChecklistSwitch: UISwitch!
    @IBOutlet weak var openWatchAppAutomaticallySwitch: UISwitch!

    // MARK: Weak Vars


    // MARK: Public Variables


    // MARK: Private Variables


    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        switch user.userDisplayUnits {
        case .freedomUnits :
            unitsSegmentedControl.isEnabledForSegment(at: 0)
        case .metric :
            unitsSegmentedControl.isEnabledForSegment(at: 1)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false //Set this becuase it gets hidden if we go to the user info screen


    }


    // MARK: IBActions

    @IBAction func unitsSegmentedControlPressed(_ sender: UISegmentedControl) {
                switch sender.selectedSegmentIndex {
                case 0:
                    user.userDisplayUnits = .freedomUnits
                case 1:
                    user.userDisplayUnits = .metric
                default:
                    print("This segmented control should only have 2 options how did we get here??")
                }
    }

    @IBAction func pauseSoundSwitchValueChanged(_ sender: UISwitch) {

    }
    @IBAction func resetChecklistSwitchValueChanged(_ sender: UISwitch) {

    }

    @IBAction func openWatchAppAutomaticallySwitchValueChanged(_ sender: UISwitch) {
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }


}






