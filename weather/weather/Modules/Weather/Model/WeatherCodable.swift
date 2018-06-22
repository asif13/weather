//
//  Weather.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

struct OpenWeather: Codable {
    var city : City
    var list : [List]
}

struct List : Codable {
    var dt : Double?
    var main : Main?
    var weather : [Weather]?
}

struct Main : Codable{
    var temp : Double?
}

struct Weather : Codable {
    var id : Int?
    var main : String?
    var description : String?
    var icon : String?
}

struct City : Codable{
    var country : String?
    var name : String?
}
