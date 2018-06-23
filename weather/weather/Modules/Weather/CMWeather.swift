//
//  Forecast.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

struct CMForecast {
    let time: String
    let icon: String
    let temperature: String
}

struct CMWeather {
    let location: String 
    let weatherDescription: String
    let date : String
    let iconText: String
    let temperature: String
    let forecasts: [CMForecast]
    let info : WeatherExtraInfo?
}

struct WeatherExtraInfo {
    var humidity : String?
    var pressure : String?
    var windSpeed : String?
    var minimumTemp : String?
    var maximumTemp : String?
}

