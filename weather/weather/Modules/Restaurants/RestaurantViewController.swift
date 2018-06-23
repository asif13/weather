//
//  RestaurantViewController.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
   
    let viewModel = RestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        updateViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateViewModel(){
       
        viewModel.fetchRestaurants()
        //closure to update view when model is updated
        viewModel.didUpdateModel = { [weak self] restaurants in
            DispatchQueue.main.async {
                print(restaurants)
            }
        }
        
        //closure to display error
        
        viewModel.didGetError = { [weak self] error in
            
            DispatchQueue.main.async {
                self?.alert("Alert", message: error.error.rawValue)
            }
            
        }
    }

}
