//
//  HikeHistoryDetailTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox

class HikeHistoryDetailTableViewController: UITableViewController, UITextFieldDelegate {
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
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    var hikeWorkout = HikeWorkout()
    
    var unsavedHikeIncoming = false
    
    // MARK: Private Variables
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        nameTextField.delegate = self
        updateDisplay()
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        updateDisplay()
        


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
        
        if hikeWorkout.hikeName != nil {
            nameTextField.text = hikeWorkout.hikeName
        }
        
        if unsavedHikeIncoming {
            saveButton.isHidden = false
            discardButton.isHidden = false
            
        } else {
            saveButton.isHidden = true
            discardButton.isHidden = true
        }
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if unsavedHikeIncoming {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 1 {
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
    
    func dismissToMainScreen() {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }

    
    // MARK: Name Text Field
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let textFieldEnteredText = textField.text
        if textFieldEnteredText != "" {
            hikeWorkout.hikeName = textFieldEnteredText
        }
        return true
    }
    
    // MARK: Hike Saving
    let saveHike = SaveHike()
    
    @IBAction func saveHikeButtonPressed(_ sender: UIButton) {
        if hikeWorkout.hikeName != nil {
            saveHike.saveToCoreData(hike: hikeWorkout)
            saveHike.saveToHealthKit(hike: hikeWorkout)
            dismissToMainScreen()
        } else {
            let alert = UIAlertController(title: "Please name your workout", message: "Message", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func discardHikeButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "Your workout will not be saved", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .destructive) { (action) in
            self.dismissToMainScreen()
        }
        let dontDeleteAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        alert.addAction(dontDeleteAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
}
