//
//  Configuration.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

//fetch configuration data from plist
class Configuration {
    
    static let `default` = Configuration()
    
    var openWeatherAccesToken : String?
    var zomatoAppId : String?
    let configurationsKey = "Configurations"

    /// Initilize configuration file with xcconfig values from plist
    func initalize(){
        
        guard let configurations = Bundle.main.infoDictionary?[configurationsKey] as? [String: Any] else { return }
        
        openWeatherAccesToken = configurations["OpenWeatherAccessToken"] as? String
        
        zomatoAppId = configurations["ZomatoAppId"] as? String
    }
    
}
