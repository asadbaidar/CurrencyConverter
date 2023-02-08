//
//  CurrencyStoreMock.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import Foundation
import Combine
@testable import CurrencyConverter

class CurrencyStoreMock: CurrencyStore {
    
    var saveRatesResult: Result<Bool, Error>!
    var didCallSaveRates = false
    
    func saveRates(_ rates: CurrencyRateData,
                   completion: @escaping (Result<Bool, Error>) -> Void) {
        didCallSaveRates = true
        completion(saveRatesResult)
    }
    
    var getRatesResult: Result<CurrencyRateData, Error>!
    var didCallGetRates = false
    
    func getRates(completion: @escaping (Result<CurrencyRateData, Error>) -> Void) {
        didCallGetRates = true
        completion(getRatesResult)
    }
}
