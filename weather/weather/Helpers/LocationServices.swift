//
//  LocationServices.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
import CoreLocation

protocol locationServiceDelegate{
    
    func didUpdateLocation(_ service: LocationService, location: CLLocation)
    
    func didFailWithError(_ service: LocationService, error: Error)
    
}
/// Location Services is responsible to fetch current location coordinates
class LocationService: NSObject {
    var delegate : locationServiceDelegate?
    let locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    func updateLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationService : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.didUpdateLocation(self, location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(self, error: error)
    }
    
}
