//
//  WError.swift
//  weather
//
//  Created by Asif Junaid on 6/22/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import Foundation

struct ErrorCodes {
    enum Code : Int {
        case urlParsing
        case networkError
        case dataParsing
        case locationFetching
    }
    let error : Code
}
