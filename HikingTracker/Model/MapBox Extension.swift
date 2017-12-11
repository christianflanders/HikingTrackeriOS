//
//  MapBox Extension.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/11/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import Mapbox

extension MGLMapView {
    
    public func drawLineOf(_ coordinates: [CLLocationCoordinate2D]) {
        let line = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        self.addAnnotation(line)
    }
    
    
    
    
}
