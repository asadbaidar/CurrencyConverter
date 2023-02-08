//
//  CurrencyApi.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation
import Combine

protocol CurrencyApi {
    
    func getRates() -> AnyPublisher<CurrencyRateData, Error>
}

class ICurrencyApi : CurrencyApi {
    let http: HttpClient
    
    init(http: HttpClient = AppHttpClient()) {
        self.http = http
    }
    
    func getRates() -> AnyPublisher<CurrencyRateData, Error> {
        return http.get(path: Endpoints.currencyRates,
                        decoder:  CurrencyDecoder())
    }
}
