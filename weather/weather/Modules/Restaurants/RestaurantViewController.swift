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
    
    @IBOutlet weak var restaurantTable: RestaurantTableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var filterViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        updateViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViews(){
        
        navigationController?.navigationBar.isHidden = false

        for view in filterViews{
            view.dropShadow()
        }
    }
    
    /// Update view model closures
    func updateViewModel(){
       
        viewModel.fetchRestaurants()
       
        //closure to update view when model is updated
        viewModel.didUpdateModel = { [weak self] restaurants in
            DispatchQueue.main.async {
                self?.restaurantTable.model = restaurants
                self?.activityIndicator.stopAnimating()
            }
        }
        
        //closure to display error
        
        viewModel.didGetError = { [weak self] error in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.alert("Alert", message: error.error.rawValue)
            }
            
        }
    }

}
