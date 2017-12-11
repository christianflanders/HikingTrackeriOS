//
//  HikeFinishedViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/9/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox

class HikeFinishedViewController: UIViewController {
    
    //MARK: Enums
    
    //MARK: Constants
    
    //MARK: Variables
    var hikeWorkout: HikeWorkout?
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
    
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let finishedHikeWorkout = hikeWorkout else {fatalError("HikeWorkout not passed properly")}
        updateDisplayWithHikeInformation(finishedHikeWorkout)

        
        //Setup map view
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapBoxView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapBoxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapBoxView.showsUserLocation = true
        mapContainerView.addSubview(mapBoxView)
        mapBoxView.drawLineOf(finishedHikeWorkout.coordinates)
        
    }
    

    //MARK: IBActions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //Store data from hike
    }
    
    @IBAction func discardButtonPressed(_ sender: UIButton) {
        //Display alert saying are you sure?
        
        //
    }
    
    
    
    
    
    //MARK: Instance Methods
    
    func updateDisplayWithHikeInformation(_ hikeWorkout: HikeWorkout) {
        let duration = hikeWorkout.duration
        durationLabel.text = duration
        let elevationGain = Int(hikeWorkout.highestElevation - hikeWorkout.lowestElevation)
        elevationGainLabel.text = String(elevationGain)
        let caloriesBurned = hikeWorkout.totalCaloriesBurned
        caloriesBurnedLabel.text = String(caloriesBurned)
        let distanceTraveled = hikeWorkout.distanceTraveled?.intValue
        totalDistanceLabel.text = String(describing: distanceTraveled)
        let timeTraveledUphill = hikeWorkout.timeTraveldUpHill
        timeUphillLabel.text = String(timeTraveledUphill)
        let timeTraveledDownhill = hikeWorkout.timeTraveledDownHill
        timeDownhillLabel.text = String(timeTraveledDownhill)
        let pace = hikeWorkout.pace?.intValue
        averagePace.text = String(describing: pace)
        
        
        
        
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
