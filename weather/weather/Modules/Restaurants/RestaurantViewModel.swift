//
//  RestaurantViewModel.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

//View Mode for restaurant module
class RestaurantViewModel: NSObject {
    let service = RestaurantService()
    var model = [CMRestaurant](){
        didSet {
            didUpdateModel?(model)
        }
    }
    //clousre called on update of model
    var didUpdateModel : (([CMRestaurant])->())?
    
    //clousure called on error
    var didGetError : ((ErrorCodes)->())?
    
    /// Fetch restaurant data
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
    
    /// Parse zomato data to create model
    ///
    /// - Parameter restaurants: restaurant object from Zomato
    /// - Returns: Restaurant Object
    func parseRetaurantData(restaurants : [Restaurant])->[CMRestaurant]{
        var models = [CMRestaurant]()
        
        for restaurant in restaurants{

            let model = CMRestaurant(
                city: restaurant.location?.city ?? "",
                cuisines: restaurant.cuisines ?? "",
                rating: Double(restaurant.user_rating?.aggregate_rating ?? "0"),
                name: restaurant.name ,
                imageUrl:  URL(string: restaurant.thumb ?? ""),
                reviewCount:  Int(restaurant.user_rating?.votes ?? "0"))
            models.append(model)
        }
        
        return models
    }
}
