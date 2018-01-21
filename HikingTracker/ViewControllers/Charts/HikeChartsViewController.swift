//
//  HikeChartsViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/31/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Charts

class HikeChartsViewController: UIViewController{

    // MARK: Enums
    
    // MARK: Constants
    
    // MARK: Variables
    
    // MARK: Outlets
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    // MARK: Weak Vars
    // MARK: Public Variables
    public var hikeWorkout: HikeInformation?
    
    // MARK: Private Variables

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        elevationGainLabel.text = hikeWorkout?.totalElevationDifferenceInMeters.getDisplayString
        
    }

    // MARK: IBActions
    
    // MARK: Charts
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Elevation" {
            let destinationVC = segue.destination as!  ElevationChartViewController
            destinationVC.hikeWorkout = hikeWorkout
        }
        if segue.identifier == "Pace" {
            let destinationVC = segue.destination as! PaceChartViewController
            destinationVC.hikeWorkout = hikeWorkout
        }
    }





}


