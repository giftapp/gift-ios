//
// Created by Matan Lachmish on 15/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationManagerConstants {
    static let distanceFilter = 20.0
}

enum LocationManagerError : Error {
    case runtimeError(String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    //Private Properties
    private let locationManager: CLLocationManager!
    private var lastKnownLocation: CLLocation?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = LocationManagerConstants.distanceFilter
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getCurrentLocation(success: @escaping (_ user : CLLocation) -> Void,
                            failure: @escaping (_ error: Error) -> Void) {
        if let lastKnownLocation = lastKnownLocation {
            success(lastKnownLocation)
        } else {
            failure(LocationManagerError.runtimeError("Location not found"))
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - CLLocationManagerDelegate
    //-------------------------------------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            Logger.debug("Updated user's location: \(location)")
            lastKnownLocation = location
        } else {
            Logger.error("Failed to find user's location: \(LocationManagerError.runtimeError("Got empty locations array"))")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.error("Failed to find user's location: \(error.localizedDescription)")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    
}
