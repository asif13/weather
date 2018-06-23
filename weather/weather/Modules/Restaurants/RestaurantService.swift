//
//  RestaurantService.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

//Service to fetch restaurant data from Zomato
class RestaurantService {
    
    let restaurantSearchUrl = "https://developers.zomato.com/api/v2.1/search"
    
    func fetchRestaurants(location : CLLocation,successblock : @escaping (([Restaurant])->()),failblock : @escaping ((ErrorCodes?)->())){
        let userkey = Configuration.default.zomatoAppId ?? ""
       
        let headers: HTTPHeaders = [
            "user-key": userkey,
            "Accept": "application/json"
        ]
        guard let url = getRestaurantSearchUrl(location: location) else { return }
        
        Alamofire.request(url,headers : headers).responseData { (response) in
            guard let data = response.data else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            
            let decoder = JSONDecoder()
            
            //decode data using swift codable
            guard let restaurants = try? decoder.decode(RestaurantCodable.self, from: data) else {
                failblock(ErrorCodes(error: .dataParsing))
                return
            }
            print(restaurants)
            let restaurantData = restaurants.restaurants.map({$0.restaurant})
            successblock(restaurantData)
        }

    }
    /// Generate url for searching restaurant
    ///
    /// - Parameter location: coordinates
    /// - Returns: Url
    private func getRestaurantSearchUrl(location : CLLocation)->URL?{
        
        guard var components = URLComponents(string:restaurantSearchUrl) else {
            return nil
        }
        
        let accessToken = Configuration.default.openWeatherAccesToken
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        //update query values
        components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:accessToken),
                                 URLQueryItem(name:"count",
                                              value:"20"),
                                 URLQueryItem(name:"sort",
                                              value:"rating"),
                                 URLQueryItem(name:"order",
                                              value:"desc")]
        return components.url
    }
}
