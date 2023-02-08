//
//  CurrencyRepositoryMock.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import Foundation
import Combine
@testable import CurrencyConverter

class CurrencyRepositoryMock: CurrencyRepository {
    
    var getRatesResult: AnyPublisher<CurrencyRateData, Error>!
    
    var didCallGetRates = false
    
    func getRates() -> AnyPublisher<CurrencyRateData, Error> {
        didCallGetRates = true
        return getRatesResult
    }
}
