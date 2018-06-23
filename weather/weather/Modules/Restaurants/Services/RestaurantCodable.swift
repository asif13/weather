//
//  RestaurantCodable.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

struct RestaurantCodable: Codable {
    var restaurants : [Restaurants]
}
struct Restaurants : Codable {
    var restaurant : Restaurant
}
struct Restaurant : Codable{
    var name : String
    var cuisines : String?
    var currency : String?
    var featured_image : String?
    var location : Location?
    var thumb : String?
    var user_rating : UserRatings?
}
struct Location : Codable {
    var city : String?
}
struct UserRatings : Codable {
    var aggregate_rating : String?
    var votes : String?
}
