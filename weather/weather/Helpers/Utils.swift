//
//  Utils.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

struct TemperatureConverter {
    static func kelvinToCelsius(_ degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    static func kelvinToFahrenheit(_ degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }
}

struct Temperature {
    let degrees: String
    
    init(country: String, openWeatherMapDegrees: Double) {
        if country == "US" {
            degrees = String(TemperatureConverter.kelvinToFahrenheit(openWeatherMapDegrees)) + "\u{f045}"
        } else {
            degrees = String(TemperatureConverter.kelvinToCelsius(openWeatherMapDegrees)) + "\u{f03c}"
        }
    }
}

struct ForecastDateTime {
    let rawDate: Double
    let timeZone: TimeZone
    
    init(date: Double, timeZone: TimeZone) {
        self.timeZone = timeZone
        self.rawDate = date
    }
    
    var shortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
}
