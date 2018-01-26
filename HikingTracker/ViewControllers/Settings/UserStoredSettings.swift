//
//  UserStoredSettings.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/25/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation

class UserStoredSettings {
   private let defaults = UserDefaults()

    var resetChecklistSetting: Bool? {
        get {
            return defaults.bool(forKey: "resetChecklist")
        }
        set {
            defaults.set(newValue, forKey:"resetChecklist")
        }
    }


    var pauseButtonSound: Bool? {
        get {
            return defaults.bool(forKey: "pauseButtonSound")
        }
        set {
            defaults.set(newValue, forKey: "pauseButtonSound")
        }
    }
    
}

