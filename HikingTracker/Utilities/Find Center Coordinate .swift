//
//  Find Center Coordinate .swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/7/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import CoreLocation

extension Array where Element: CLLocation {
    func calculateCenterCoordinate() -> CLLocationCoordinate2D {
        let totalLat = self.reduce(0.0) { $0 + $1.coordinate.latitude }
        let totalLong = self.reduce(0.0) { $0 + $1.coordinate.longitude }
        let averageLat = totalLat / Double(self.count)
        let averageLong = totalLong / Double(self.count)
        let calculatedCenterCoordinate = CLLocationCoordinate2D(latitude: averageLat, longitude: averageLong)
        return calculatedCenterCoordinate
    }
}

