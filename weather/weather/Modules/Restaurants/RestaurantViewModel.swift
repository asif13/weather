//
//  RestaurantViewModel.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

class RestaurantViewModel: NSObject {
    let service = RestaurantService()
    var model = [CMRestaurant](){
        didSet {
            didUpdateModel?(model)
        }
    }
    
    var didUpdateModel : (([CMRestaurant])->())?
    
    var didGetError : ((ErrorCodes)->())?
    
    func fetchRestaurants(){
        
        guard let location = Utils.currentLocation else { return }
        
        service.fetchRestaurants(location: location , successblock: { [weak self] (restaurants) in
            
            DispatchQueue.main.async {
                if let model = self?.parseRetaurantData(restaurants: restaurants){
                    self?.model = model
                }
            }
            
        }) {  [weak self] (errorCodes) in
            
            if let error = errorCodes{
               
                DispatchQueue.main.async {
                   
                    self?.didGetError?(error)

                }
            }
        }
    }
    func parseRetaurantData(restaurants : [Restaurant])->[CMRestaurant]{
        var models = [CMRestaurant]()
        
        for restaurant in restaurants{

            let model = CMRestaurant(
                cuisines: restaurant.cuisines ?? "",
                rating: restaurant.user_ratings?.aggregate_rating ?? 0,
                name: restaurant.name ?? "",
                imageUrl:  URL(string: restaurant.thumb ?? ""),
                reviewCount: restaurant.user_ratings?.votes ?? 0)
            models.append(model)
        }
        
        return models
    }
}