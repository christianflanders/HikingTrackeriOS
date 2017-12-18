//
//  HikeFinishedViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/9/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox
import CoreData
import HealthKit

class HikeFinishedViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Enums
    
    //MARK: Constants
    private let saveSegueIdentifier = "SaveHikeSegue"
    //MARK: Variables
    weak var hikeWorkout: HikeWorkout?
    var mapBoxView: MGLMapView!
    
    //MARK: Outlets
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
    @IBOutlet weak var paceUphillLabel: UILabel!
    @IBOutlet weak var paceDownhillLabel: UILabel!
    @IBOutlet weak var timeUphillLabel: UILabel!
    @IBOutlet weak var timeDownhillLabel: UILabel!
    @IBOutlet weak var averagePace: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var nameHikeTextField: UITextField!
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    private var hikeWorkoutName: String?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        nameHikeTextField.delegate = self
        super.viewDidLoad()
        guard let finishedHikeWorkout = hikeWorkout else {fatalError("HikeWorkout not passed properly")}
        updateDisplayWithHikeInformation(finishedHikeWorkout)

        
        //Setup map view
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapBoxView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapBoxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapBoxView.showsUserLocation = true
        mapContainerView.addSubview(mapBoxView)
        
        if (hikeWorkout?.coordinates.count)! > 1 {
            mapBoxView.drawLineOf(finishedHikeWorkout.coordinates)
            let bounds = MGLCoordinateBounds(sw: finishedHikeWorkout.coordinates.first!, ne: finishedHikeWorkout.coordinates.last!)
            mapBoxView.setVisibleCoordinateBounds(bounds, animated: true)
        }

        
    }
    

    //MARK: IBActions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //Store data from hike
        guard let finishedHikeWorkout = hikeWorkout else {fatalError("HikeWorkout not passed properly")}
        let persistanceService = PersistanceService.store
        guard let hikeWorkoutName = hikeWorkoutName else {
            presentAlert(title: "Please name your workout!", message: "Got it", view: self)
            return
        }
        persistanceService.storeHikeWorkout(hikeWorkout: finishedHikeWorkout, name: hikeWorkoutName)
        
        let saved = persistanceService.fetchedWorkouts
        print("the number of workouts saved is \(saved.count)")
        
        let healthKit = HealthKitStore()
        
        healthKit.storeHikeToHealthKit(finishedHikeWorkout, name: hikeWorkoutName)
        
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: saveSegueIdentifier, sender: self)
        
        
    }
    
    @IBAction func discardButtonPressed(_ sender: UIButton) {
        //Display alert saying are you sure?
        
        //
        
        
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    
    
    
    
    //MARK: Instance Methods
    
    func updateDisplayWithHikeInformation(_ hikeWorkout: HikeWorkout) {
        let duration = hikeWorkout.durationAsString
        durationLabel.text = duration
        let elevationGain = Int(hikeWorkout.highestElevation - hikeWorkout.lowestElevation)
        elevationGainLabel.text = String(elevationGain)
        let caloriesBurned = hikeWorkout.totalCaloriesBurned
        caloriesBurnedLabel.text = String(caloriesBurned)
        let distanceTraveled = hikeWorkout.totalDistanceTraveled
        totalDistanceLabel.text = String(describing: distanceTraveled)
        let timeTraveledUphill = hikeWorkout.timeTraveldUpHill
        timeUphillLabel.text = String(timeTraveledUphill)
        let timeTraveledDownhill = hikeWorkout.timeTraveledDownHill
        timeDownhillLabel.text = String(timeTraveledDownhill)
//        let pace = hikeWorkout.pace?.intValue
//        averagePace.text = String(describing: pace)

        
    }
    

    
    //MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldsText = textField.text
        if textFieldsText != "" {
            hikeWorkoutName = textFieldsText
        }
        textField.resignFirstResponder()
        return true
    }
    
}
