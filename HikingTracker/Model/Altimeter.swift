//
//  Altimeter.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/5/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import CoreMotion

class Altimeter {
    static let shared = CMAltimeter()
    
    private init() {
        
    }
}
