//
//  Constants.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation

/// This class is not meant to be instantiated;
class Constants {
    /// This constructor prevents instantiation.
    private init() {}
    
    static let appId = ["app_id" : "e2059ec116cd44fe81f781b5c8deabdd"]
    static let httpConfig = HttpConfig(baseUrl: Endpoints.baseUrl, apiKey: Constants.appId)
}
