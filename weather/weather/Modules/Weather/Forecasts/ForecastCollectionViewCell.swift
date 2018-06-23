//
//  ForecastCollectionViewCell.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var temperature: UILabel!
   
    //update cell data
    func updateCell(forecast : CMForecast){
        time.text = forecast.time
        temperature.text = forecast.temperature
        icon.text = forecast.icon
    }
}
