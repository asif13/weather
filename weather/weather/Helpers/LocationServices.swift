//
//  LocationServices.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
import CoreLocation

protocol locationServiceDelegate{
    
}
/// Location Services is responsible to fetch current location coordinates
class LocationServices: NSObject {
    var delegate : LocationServices?
    let locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    func updateLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationServices : CLLocationManagerDelegate{
    
}
