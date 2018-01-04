//
//  HikeInProgressStatDisplay.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/3/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class HikeInProgressStatDisplay: UIView {
    
    @IBOutlet weak var altitudeDisplayLabel: UILabel!
    @IBOutlet weak var durationDisplayLabel: UILabel!
    @IBOutlet weak var paceDisplayLabel: UILabel!
    @IBOutlet weak var distanceDisplayLabel: UILabel!
    @IBOutlet weak var caloriesBurnedDisplayLabel: UILabel!
    @IBOutlet weak var sunsetBurnedDisplayLabel: UILabel!
    
    
    @IBOutlet weak var statsStackView: UIStackView!
    @IBOutlet weak var hikeStatDisplayView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    
    func didLoad() {

        Bundle.main.loadNibNamed("HikeInProgressStatDisplay", owner: self, options: nil)
//        hikeStatDisplayView.translatesAutoresizingMaskIntoConstraints = false
//        self.layoutSubviews()
        hikeStatDisplayView.frame = self.bounds
        hikeStatDisplayView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(hikeStatDisplayView)
        statsStackView.frame = hikeStatDisplayView.bounds
        statsStackView.autoresizingMask = [.flexibleWidth,.flexibleHeight]

    

//        hikeStatDisplayView.bounds = self.bounds
//        hikeStatDisplayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //Place your initialization code here
        
        //I actually create & place constraints in here, instead of in
        //updateConstraints
    }
    
    func setDisplay(with hikeDisplay: HikeInProgressDisplay) {
        altitudeDisplayLabel.text = hikeDisplay.altitude
        durationDisplayLabel.text = hikeDisplay.duration
        paceDisplayLabel.text? = hikeDisplay.pace
        distanceDisplayLabel.text = hikeDisplay.distance
        caloriesBurnedDisplayLabel.text = hikeDisplay.caloriesBurned
        sunsetBurnedDisplayLabel.text = hikeDisplay.sunsetTime
    }
}



