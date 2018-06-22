//
//  WeatherService.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class WeatherService {
   
    let weatherApiurl = "http://api.openweathermap.org/data/2.5/forecast"
    
    func fetchWeatherInformation(location : CLLocation,successblock : @escaping ((CMWeather)->()),failblock : @escaping ((ErrorCodes?)->())){
        
        guard let url = getWeatherInfoUrl(location: location) else { return }


        Alamofire.request(url).validate().responseData { (response) in
            print(response)
            
            guard let data = response.data else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let weather = try? decoder.decode(OpenWeather.self, from: data) else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            guard weather.list.count > 0 else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            let list = weather.list[0]
            
            var forecasts = [CMForecast]()
            
            for list in weather.list[0..<3]{
                let temperature = Temperature(country: weather.country ?? "", openWeatherMapDegrees:list.main?.temp ?? 0)
                let forecastTemperature =  temperature.degrees
                let forecastTime = ForecastDateTime(date: list.dt ?? 0, timeZone: TimeZone.current).shortTime
                let forecast = CMForecast(time: forecastTime, icon: "", temperature: forecastTemperature)
                forecasts.append(forecast)
            }
            
            let temperature = Temperature(country: weather.country ?? "", openWeatherMapDegrees:list.main?.temp ?? 0)
            
            let forecastTemperature =  temperature.degrees
            let weatherIcon = WeatherIcon(condition: list.weather?.first?.id ?? 0, iconString: list.weather?.first?.icon ?? "")
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let dayInWeek = formatter.string(from: date)
            
            let cmWeather = CMWeather(location: self.getCorrectCityName(city: weather.city.name ?? ""), weatherDescription: list.weather?.first?.weatherDescription ?? "", date: dayInWeek, iconText: weatherIcon.iconText, temperature: forecastTemperature, forecasts: forecasts)

            successblock(cmWeather)
        }
    }
    
    /// wrong names provided by open weather api .
    fileprivate func getCorrectCityName(city : String)->String{
        
        if city == "Dubayy" {
            return "Dubai"
        }
        
        return city
    }
    private func getWeatherInfoUrl(location : CLLocation)->URL?{
        
        guard var components = URLComponents(string:weatherApiurl) else {
            return nil
        }
        
        let accessToken = Configuration.default.openWeatherAccesToken
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        //update query values
        components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:accessToken),
                                 URLQueryItem(name:"cnt",
                                              value:"5")]
       
        return components.url
    }
}
