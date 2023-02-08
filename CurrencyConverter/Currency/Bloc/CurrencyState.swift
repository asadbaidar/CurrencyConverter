//
//  CurrencyState.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 07/02/2023.
//

import Foundation
import SwiftUI

typealias CurrencyRateApiState = ApiState<CurrencyRateData>

struct CurrencyState: Equatable {
    var apiState: CurrencyRateApiState = .init()
    var currency: String = "USD"
    var amount: Double = 0
}

extension CurrencyState {
    
    var data: CurrencyRateData? { apiState.data }
    
    var currencies: [String] { data?.currencies ?? [] }
    
    var rates: CurrencyRates { data?.rates ?? [:] }
    
    func converted(to toCurrency: String) -> LocalizedStringKey {
        data?.convert(amount: amount,
                      from: currency,
                      to: toCurrency).formatted2f ?? ""
        
    }
}
