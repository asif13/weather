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
    
    var didGetError : ((ErrorCodes)->())?

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
    
    /// Parse open weather data to created model for CMWeather to be consumed by view
    ///
    /// - Parameter weather: Open Weather data from server
    /// - Returns: CMWeather object
    func parseWeatherData(weather : OpenWeather) -> CMWeather {
        
        //extract data to display current weather
        let currentWeather = weather.list[0].weather?.first
        
        let temperature = Temperature(country: weather.country ?? "", openWeatherMapDegrees:weather.list[0].main?.temp ?? 0)
        
        let forecastTemperature =  temperature.degrees
        
        let weatherIcon = WeatherIcon(condition: currentWeather?.id ?? 0, iconString: currentWeather?.icon ?? "")
        
        let location = getCorrectCityName(city: weather.city.name ?? "")
        
        let day = Utils.getCurrentDay()
        
        //get future forcasts
        let forecasts = self.getForecastInfo(weather: weather)
        
        let cmWeather = CMWeather(
            location: location ,
            weatherDescription: currentWeather?.weatherDescription ?? "",
            date: day,
            iconText: weatherIcon.iconText,
            temperature: forecastTemperature,
            forecasts: forecasts
        )
        
        return cmWeather
    }
    
    /// wrong names provided by open weather api .
    fileprivate func getCorrectCityName(city : String)->String{
        
        if city == "Dubayy" {
            return "Dubai"
        }
        
        return city
    }
    
    fileprivate func getForecastInfo(weather : OpenWeather) ->  [CMForecast]{
        var forecasts = [CMForecast]()
        
        for list in weather.list[0..<7] {
            let temperature = Temperature(country: weather.country ?? "", openWeatherMapDegrees:list.main?.temp ?? 0)
            let forecastTemperature =  temperature.degrees
            let forecastTime = ForecastDateTime(date: list.dt ?? 0, timeZone: TimeZone.current).shortTime
            let weatherIcon = WeatherIcon(condition: list.weather?.first?.id ?? 0, iconString: list.weather?.first?.icon ?? "")
            
            let forecast = CMForecast(time: forecastTime,
                                      icon: weatherIcon.iconText,
                                      temperature: forecastTemperature)
            forecasts.append(forecast)
        }
        return forecasts
    }
}

extension WeatherViewModel : locationServiceDelegate{
   
    func didUpdateLocation(_ service: LocationService, location: CLLocation) {
       
        weatherService.fetchWeatherInformation(location: location, successblock: { [weak self] weather in
            
            self?.model = self?.parseWeatherData(weather: weather)
            
        }) { [weak self] (errorCodes) in
            
            if let error = errorCodes{
                
                self?.didGetError?(error)
                
            }
            
        }
    }
    
    func didFailWithError(_ service: LocationService, error: Error) {
        
    }
    
}
