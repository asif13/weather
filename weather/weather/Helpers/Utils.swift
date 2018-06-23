//
//  Utils.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
import CoreLocation
struct Utils {
    
    static var currentLocation : CLLocation?
    
    //get current day
    static func getCurrentDay()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        return dayInWeek
    }
}
//convert degrees to celcius or fahrenheit
struct TemperatureConverter {
    static func kelvinToCelsius(_ degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    static func kelvinToFahrenheit(_ degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }
}

//convert datetime to time format displayed for forecast
struct ForecastDateTime {
    let rawDate: Double
    let timeZone: TimeZone
    
    init(date: Double, timeZone: TimeZone) {
        self.timeZone = timeZone
        self.rawDate = date
    }
    
    var shortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
}
extension UIView {
    /// Used to simplify loading from a view
    ///
    /// - Returns: Inferred UIView type
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    //Drop shadow on views
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.30).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
