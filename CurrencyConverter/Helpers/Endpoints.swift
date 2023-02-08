//
//  Endpoints.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation

/// This class is not meant to be instantiated;
class Endpoints {
    /// This constructor prevents instantiation.
    private init() {}
    
    static let baseUrl = "https://openexchangerates.org/api/"
    static let currencyRates = "latest.json"
}

