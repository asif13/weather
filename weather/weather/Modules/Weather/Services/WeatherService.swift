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

//Service to fetch weather data from open weather map
class WeatherService {
   
    let weatherApiurl = "http://api.openweathermap.org/data/2.5/forecast"
    
    func fetchWeatherInformation(location : CLLocation,successblock : @escaping ((OpenWeather)->()),failblock : @escaping ((ErrorCodes?)->())){
        
        guard let url = getWeatherInfoUrl(location: location) else { return }


        Alamofire.request(url).validate().responseData { (response) in
            
            guard let data = response.data else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            
            let decoder = JSONDecoder()
            
            //decode data using swift codable
            guard let weather = try? decoder.decode(OpenWeather.self, from: data) else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            guard weather.list.count > 0 else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            successblock(weather)
        }
    }
    
    
    /// Generate url for fetching weather
    ///
    /// - Parameter location: coordinates
    /// - Returns: Url
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
                                              value:"10")]
       
        return components.url
    }
}
