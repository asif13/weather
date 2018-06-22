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
    let iconText: String
    let temperature: String
    let forecasts: [CMForecast]
}
