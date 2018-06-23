//
//  WError.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

struct ErrorCodes {
    enum Code : String {
        case urlParsing = "Failed to parse url"
        case networkError = "Network error"
        case dataParsing = "Failed to parse data"
        case locationFetching = "Failed to fetch location"
    }
    let error : Code
}
