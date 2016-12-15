//
// Created by Matan Lachmish on 15/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import CoreLocation

class LocationUtils {

    static func distanceBetween(lat1: Double, lng1: Double,
                                lat2: Double, lng2: Double) -> Double {
        let coordinate1 = CLLocation(latitude: lat1, longitude: lng1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: lng2)

        return coordinate1.distance(from: coordinate2) / 1000.0
    }

}
