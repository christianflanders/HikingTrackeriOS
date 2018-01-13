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


    // MARK: IBActions

    @IBAction func unitsSegmentedControlPressed(_ sender: UISegmentedControl) {
        
    }

    @IBAction func pauseSoundSwitchValueChanged(_ sender: UISwitch) {

    }
    @IBAction func resetChecklistSwitchValueChanged(_ sender: UISwitch) {

    }

    @IBAction func openWatchAppAutomaticallySwitchValueChanged(_ sender: UISwitch) {
    }


}






