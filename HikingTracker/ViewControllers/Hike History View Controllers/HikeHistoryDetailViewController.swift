//
//  HikeHistoryDetailViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/12/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox

class HikeHistoryDetailViewController: UIViewController {

    var hikeWorkout = HikeWorkout()
    
    
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
    @IBOutlet weak var paceUphillLabel: UILabel!
    @IBOutlet weak var paceDownhillLabel: UILabel!
    @IBOutlet weak var timeUphillLabel: UILabel!
    @IBOutlet weak var timeDownhillLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    var mapBoxView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elevationGainLabel.text = String((hikeWorkout.highestElevation - hikeWorkout.lowestElevation).asFeet)
        totalDistanceLabel.text = String(describing: hikeWorkout.totalDistanceTraveled?.asMiles)
        durationLabel.text = hikeWorkout.durationAsString
        caloriesBurnedLabel.text = String(hikeWorkout.totalCaloriesBurned)
        timeUphillLabel.text = String(hikeWorkout.timeTraveldUpHill)
        timeDownhillLabel.text = String(hikeWorkout.timeTraveledDownHill)
//        averagePaceLabel.text = String(hikeWorkout.totalDistanceTraveled! / Double(hikeWorkout.seconds))
        // Do any additional setup after loading the view.
        
        
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapBoxView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapBoxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapContainerView.addSubview(mapBoxView)
        if hikeWorkout.coordinates.count > 2 {
            mapBoxView.drawLineOf(hikeWorkout.coordinates)
            let bounds = MGLCoordinateBounds(sw: hikeWorkout.coordinates.first!, ne: hikeWorkout.coordinates.last!)
            mapBoxView.setVisibleCoordinateBounds(bounds, animated: true)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    

}
