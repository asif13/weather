//
//  Weather.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
//Model to map data from open weather 
struct OpenWeather: Codable {
    var city : City
    var country : String?
    var list : [List]
}

struct List : Codable {
    var dt : Double?
    var main : Main?
    var weather : [Weather]?
}

struct Main : Codable{
    var temp : Double?
    var pressure : Double?
    var humidity : Double?
    var temp_max : Double?
    var temp_min : Double?
}

struct Weather : Codable {
    var id : Int?
    var main : String?
    var description : String?
    var wind : Wind?
    var weatherDescription : String? {
        return description
    }
    
    var icon : String?
}

struct City : Codable{
    var country : String?
    var name : String?
}
struct Wind : Codable {
    var speed : Double?
}
