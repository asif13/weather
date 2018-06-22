//
//  WeatherDetailViewModel.swift
//  weather
//
//  Created by Asif Junaid on 6/21/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    
    var locationService : LocationService
    var weatherService : WeatherService
    var model : CMWeather? {
        didSet {
            didUpdateModel?(model)
        }
    }
    
    var didUpdateModel : ((CMWeather?)->())?
    
    init() {
        locationService = LocationService()
        weatherService = WeatherService()
    }
    
    /// Updates current location
    func updateCurrentLocation(){
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.locationService.delegate = self
            self.locationService.updateLocation()
        }
    }
}

extension WeatherViewModel : locationServiceDelegate{
   
    func didUpdateLocation(_ service: LocationService, location: CLLocation) {
       
        weatherService.fetchWeatherInformation(location: location, successblock: { [weak self] weather in
            
            self?.model = weather
            
        }) { (errorCodes) in
            
        }
        
    }
    
    func didFailWithError(_ service: LocationService, error: Error) {
        
    }
    
}
