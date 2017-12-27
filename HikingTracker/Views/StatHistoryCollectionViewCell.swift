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
            statValue.text = distanceDisplayString
            statImage.image = #imageLiteral(resourceName: "distance option 2")
            
        case .elevationGain:
            statName.text = "Elevation Gain"
            let elevationGain = hikeWorkout.highestElevation - hikeWorkout.lowestElevation
            let elevationGainString = elevationGain.getDisplayString
            statValue.text = elevationGainString
            statImage.image = #imageLiteral(resourceName: "Mountain")
            
        case .calories:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .avgPace:
            statName.text = "Avg. Pace"
            let caloriesBurned = hikeWorkout.totalDistanceTraveled! / hikeWorkout.duration
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .avgHeartRate:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .minAltitude:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .maxAltitude:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
            let calorieString = "/(caloriesBurned) kcal"
            statValue.text = calorieString
            statImage.image = #imageLiteral(resourceName: "Flame")
        case .timeUphill:
            statName.text = "Calories"
            let caloriesBurned = hikeWorkout.totalCaloriesBurned
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
