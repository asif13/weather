//
//  WeatherDetailViewController.swift
//  weather
//
//  Created by Asif Junaid on 6/21/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var viewModel : WeatherViewModel?
    
    @IBOutlet var weatherDetails: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewModel(){
        viewModel = WeatherViewModel()
        viewModel?.updateCurrentLocation()
        viewModel?.didUpdateModel = { [weak self] weather in
            DispatchQueue.main.async {
                self?.weatherDetails[0].text = weather?.location ?? ""
                self?.weatherDetails[2].text = weather?.temperature ?? ""

            }
        }
    }
}
