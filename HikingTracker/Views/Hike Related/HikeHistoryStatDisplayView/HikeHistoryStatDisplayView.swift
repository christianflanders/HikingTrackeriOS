//
//  HikeHistoryStatDisplayView.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/5/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit

class HikeHistoryStatDisplayView: UIView {
    
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
    
    
    @IBOutlet weak var statsStackView: UIStackView!
    @IBOutlet weak var hikeStatDisplayView: UIView!
    
    
//    var hikeDisplay = HikeFinishedDisplay()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    
    func didLoad() {
        
        Bundle.main.loadNibNamed("HikeHistoryStatDisplayView", owner: self, options: nil)
        hikeStatDisplayView.translatesAutoresizingMaskIntoConstraints = false
        self.layoutSubviews()
        hikeStatDisplayView.frame = self.bounds
        hikeStatDisplayView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(hikeStatDisplayView)
        statsStackView.frame = hikeStatDisplayView.bounds
        statsStackView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    

    func updateDisplay() {


        
    }
}
