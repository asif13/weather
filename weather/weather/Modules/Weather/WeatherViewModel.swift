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
    //closure called when model is updated
    var didUpdateModel : ((CMWeather?)->())?
    
    //clousre called on error
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
        
        let extraInfo = self.getExtraInfo(weather: weather)
        
        let cmWeather = CMWeather(
            location: location ,
            weatherDescription: currentWeather?.weatherDescription ?? "",
            date: day,
            iconText: weatherIcon.iconText,
            temperature: forecastTemperature,
            forecasts: forecasts,
            info: extraInfo
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
    
    /// Parse forecast data from open weather
    ///
    /// - Parameter weather: open weather model
    /// - Returns: array of CMForecast
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
    
    /// Parse addition weather info
    ///
    /// - Parameter weather: open weather model
    /// - Returns: WeatherExtraInfo object
    fileprivate func getExtraInfo(weather: OpenWeather)->WeatherExtraInfo{
        
        guard let list = weather.list.first else {
            return WeatherExtraInfo(humidity: "", pressure: "", windSpeed: "", minimumTemp : "", maximumTemp : "")
        }
        
        let humidty = list.main?.humidity ?? 0
        let pressure = list.main?.pressure ?? 0
        let windSpeed = list.weather?.first?.wind?.speed ?? 0
        let minimumTemp = Temperature(country: weather.country ?? "", openWeatherMapDegrees:list.main?.temp_min ?? 0).degrees
        
        let maximumTemp = Temperature(country: weather.country ?? "", openWeatherMapDegrees:list.main?.temp_max ?? 0).degrees
        
        let info = WeatherExtraInfo(
            humidity: "\(humidty) %",
            pressure: "\(convertHpaToPsi(hpa: pressure)) psi",
            windSpeed: "\(windSpeed) m/sec",
            minimumTemp : minimumTemp,
            maximumTemp : maximumTemp
        )
        
        return info
        
    }
    /// Converts atomsperic pressure from hpa to psi
    ///
    /// - Parameter hpa: data
    /// - Returns: psi value
    fileprivate func convertHpaToPsi(hpa : Double) -> Int{
        return Int(hpa * 0.014)
    }
}

extension WeatherViewModel : locationServiceDelegate{
    //delegate called on update of location
    func didUpdateLocation(_ service: LocationService, location: CLLocation) {
       
        //fetch weather infor from service
        weatherService.fetchWeatherInformation(location: location, successblock: { [weak self] weather in
            
            self?.model = self?.parseWeatherData(weather: weather)
            
        }) { [weak self] (errorCodes) in
            
            if let error = errorCodes{
                
                self?.didGetError?(error)
                
            }
            
        }
    }
    //delegate called on error
    func didFailWithError(_ service: LocationService, error: Error) {
        didGetError?(ErrorCodes(error: .locationFetching))
    }
    
}
