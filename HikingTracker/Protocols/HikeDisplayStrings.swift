//
//  HikeDisplayStrings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/5/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation

class HikeInProgressDisplay {
    //Contains all the strings we need for the hike in progress screen
    // The current hike object creates one for us, which we give to the Hike In Progress stat display view to put on screen
    
    var duration = "-"
    var altitude = "-"
    var distance = "-"
    var caloriesBurned = "-"
    final var pace = "-"
    final var sunsetTime = "-"
}

class HikeFinishedDisplayStrings: HikeInProgressDisplay {
    var elevationGain = "-"
    var avgPace = "-"
    var avgHeartRate = "-"
    var minAlitude = "-"
    var maxAltitude = "-"
    var timeUphill = "-"
    var timeDownill = "-"
    
}



