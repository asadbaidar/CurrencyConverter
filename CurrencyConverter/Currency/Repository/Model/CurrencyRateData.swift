//
//  CurencyRateEntity.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation

typealias CurrencyRates = [String : Double]

struct CurrencyRateData: Hashable, Codable, Equatable {
    public let timestamp: Date
    public let base: String
    public let rates: CurrencyRates
    
    init(
        timestamp: Date = Date.now,
        base: String = "",
        rates: CurrencyRates = [:]
    ) {
        self.timestamp = timestamp
        self.base = base
        self.rates = rates
    }
    
    func copyWith(
        timestamp: Date? = nil,
        base: String? = nil,
        rates: CurrencyRates? = nil
    ) -> CurrencyRateData {
        return CurrencyRateData(
            timestamp: timestamp ?? self.timestamp,
            base: base ?? self.base,
            rates: rates ?? self.rates
        )
    }
}

extension CurrencyRateData {
    
    public var currencies: [String] { rates.keys.sorted() }
    
    public var isOlderThanHalfHour: Bool { timestamp.distance(to: Date.now) > 30.minutes }
    
    func modified() -> CurrencyRateData {
        copyWith(timestamp: Date.now)
    }
    
    func convert(amount: Double, from fromCurrency: String, to toCurrency: String) -> Double {
        return amount * rates[toCurrency]! / rates[fromCurrency]!
    }
}

class CurrencyDecoder: JSONDecoder {
    override init() {
        super.init()
        self.dateDecodingStrategy = .secondsSince1970
    }
}

class CurrencyEncoder: JSONEncoder {
    override init() {
        super.init()
        self.dateEncodingStrategy = .secondsSince1970
    }
}
