//
//  SaveHikeWorkout.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/1/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreData
import HealthKit

struct SaveHike {
    
    func saveToCoreData(hike: HikeWorkout) {
        guard let hikeName = hike.hikeName else { return }
        let dataStore = PersistanceService.store
        dataStore.storeHikeWorkout(hikeWorkout: hike, name: hikeName)
    }
    
    func saveToHealthKit(hike: HikeWorkout) {
        guard let hikeName = hike.hikeName else { return }
        let healthKit = HealthKitStore()
        healthKit.storeHikeToHealthKit(hike, name: hikeName)
    }
}


