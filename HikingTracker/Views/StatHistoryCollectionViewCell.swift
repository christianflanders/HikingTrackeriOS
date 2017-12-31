//
//  StatHistoryCollectionViewCell.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class StatHistoryCollectionViewCell: UICollectionViewCell {
    
    var hikeWorkout = HikeWorkout()
    
//    let statsOptions: [stats] = [.duration, .distance, . elevationGain, .calories, .avgPace, .avgHeartRate, .minAltitude, .maxAltitude, .timeUphill, .timeDownhill]
    
    
    
    
    @IBOutlet weak var statImage: UIImageView!
    @IBOutlet weak var statName: UILabel!
    @IBOutlet weak var statValue: UILabel!
    
    
    func setCellForStat(_ stat: Stats){
        var unitString = ""
        let user = StoredUser()
        let userUnitPreference = user.userDisplayUnits
        switch userUnitPreference {
        case .freedomUnits:
            unitString = "ft"
        case .metric:
            unitString = "mtrs"
        }
        switch stat {
        case .duration:
            statName.text = "Duration"
            let duration = hikeWorkout.durationAsString
            statValue.text = duration
            statImage.image = #imageLiteral(resourceName: "Clock")
            
        case .distance:
            statName.text = "Distance"
            let distance = hikeWorkout.totalDistanceTraveled
            let distanceDisplayString = distance?.getDisplayString
            statValue.text = "\(distanceDisplayString) \(unitString)"
            statImage.image = #imageLiteral(resourceName: "distance option 2")
            
        case .elevationGain:
            statName.text = "Elevation Gain"
            let elevationGain = hikeWorkout.highestElevation - hikeWorkout.lowestElevation
            let elevationGainString = "\(elevationGain.getDisplayString) \(unitString)"
            statValue.text = elevationGainString
            statImage.image = #imageLiteral(resourceName: "Mountain")
            
        case .calories:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "\(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .avgPace:
            statName.text = "Avg. Pace"
            let pace = hikeWorkout.totalDistanceTraveled! / hikeWorkout.duration
            let paceString = "\(pace) \(unitString)/hr"
            statValue.text = paceString
            statImage.image = #imageLiteral(resourceName: "Speedometer")
        case .avgHeartRate:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "\(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .minAltitude:
            statName.text = "Min Altitude"
            let minAltitude = hikeWorkout.lowestElevation.getDisplayString
            let minAltitudeString = "\(minAltitude) \(unitString)"
            statValue.text = minAltitudeString
            statImage.image = #imageLiteral(resourceName: "Mountain")
        case .maxAltitude:
            statName.text = "Max Altitude"
            let maxAltitude = hikeWorkout.highestElevation
            let maxAltitudeString = "\(maxAltitude) \(unitString)"
            statValue.text = maxAltitudeString
            statImage.image = #imageLiteral(resourceName: "Mountain With Flag")
        case .timeUphill:
            statName.text = "Time Uphill"
            let caloriesBurned = hikeWorkout.timeTraveldUpHill
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .timeDownhill:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        default:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        }
    }
}
