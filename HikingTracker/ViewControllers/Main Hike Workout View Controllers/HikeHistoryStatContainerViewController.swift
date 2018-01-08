//
//  HikeHistoryStatContainerViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/5/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class HikeHistoryStatContainerViewController: UIViewController {
    
    
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

    var hikeDisplay: HikeFinishedDisplayStrings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateDisplay(with: hikeDisplay)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDisplay(hike: HikeFinishedDisplayStrings ) {
        durationLabel.text = hike.duration
        distanceLabel.text = hike.distance
        elevationGainLabel.text = hike.elevationGain
        caloriesLabel.text = hike.caloriesBurned
        avgPaceLabel.text = hike.avgPace
        minAltitudeLabel.text = hike.minAlitude
        maxAltitudeLabel.text = hike.maxAltitude
        timeUphillLabel.text = hike.timeUphill
        timeDownhillLabel.text = hike.timeDownill
        
    }
    
    func goAway() {
        self.dismiss(animated: true, completion: nil)
    }

}
