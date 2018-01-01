//
//  HikeHistoryDetailTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox

class HikeHistoryDetailTableViewController: UITableViewController {
    // MARK: Enums
    
    // MARK: Constants
    let statsToDisplay: [Stats] = [.duration, .distance, . elevationGain, .calories, .avgPace, .avgHeartRate, .minAltitude, .maxAltitude, .timeUphill, .timeDownhill]
    
    
    // MARK: Variables
    var mapBoxView: MGLMapView!
    
    // MARK: Outlets
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var avgHeartRateLabel: UILabel!
    @IBOutlet weak var minAltitudeLabel: UILabel!
    @IBOutlet weak var maxAltitudeLabel: UILabel!
    @IBOutlet weak var timeUphillLabel: UILabel!
    @IBOutlet weak var timeDownhillLabel: UILabel!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    var hikeWorkout = HikeWorkout()
    
    var doneButtonNeeded = false
    
    // MARK: Private Variables
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        updateDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        updateDisplay()
        
        if doneButtonNeeded {
            doneButton.isHidden = false
        } else {
            doneButton.isHidden = true
        }

    }
    // MARK: IBActions

    // MARK: Stat Display
    
    func updateDisplay() {
        durationLabel.text = hikeWorkout.durationAsString
        distanceLabel.text = hikeWorkout.totalDistanceTraveled?.getDisplayString
        elevationGainLabel.text = (hikeWorkout.highestElevation - hikeWorkout.lowestElevation).getDisplayString
        caloriesLabel.text = hikeWorkout.totalCaloriesBurned.getCalorieDisplayString
        
        
        minAltitudeLabel.text = hikeWorkout.lowestElevation.getDisplayString
        maxAltitudeLabel.text = hikeWorkout.highestElevation.getDisplayString
        
        timeUphillLabel.text = String(hikeWorkout.timeTraveldUpHill)
        timeDownhillLabel.text = String(hikeWorkout.timeTraveledDownHill)
        
    }
    
    func setUpMapBoxView() {
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapBoxView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapBoxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapContainerView.addSubview(mapBoxView)
    }

    func mapBoxDrawHistoryLine() {
        if hikeWorkout.coordinates.count > 2 {
            mapBoxView.drawLineOf(hikeWorkout.coordinates)
            let bounds = MGLCoordinateBounds(sw: hikeWorkout.coordinates.first!, ne: hikeWorkout.coordinates.last!)
            mapBoxView.setVisibleCoordinateBounds(bounds, animated: true)
        }
        
    }
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "Chart View", sender: self)
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chart View" {
            let destinationVC = segue.destination as! HikeChartsViewController
            destinationVC.hikeWorkout = hikeWorkout
        }
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
}
