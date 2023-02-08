//
//  CurrencyStore.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import Foundation
import Combine

protocol CurrencyStore {
    
    func getRates(completion: @escaping (Result<CurrencyRateData, Error>) -> Void)
    
    func saveRates(_ rates: CurrencyRateData,
                   completion: @escaping (Result<Bool, Error>) -> Void)
}

extension CurrencyStore {
    func saveRates(_ rates: CurrencyRateData,
                   completion: ((Result<Bool, Error>) -> Void)? = nil) {
        return saveRates(rates,
                        completion: completion ?? { _ in })
    }
}

class ICurrencyStore: CurrencyStore {
    let store: StoreClient
    
    init(store: StoreClient = IStoreClient()) {
        self.store = store
    }
    
    func getRates(completion: @escaping (Result<CurrencyRateData, Error>) -> Void) {
       return store.read(decoder: CurrencyDecoder(),
                         completion: completion)
    }
    
    func saveRates(_ rates: CurrencyRateData,
                   completion: @escaping (Result<Bool, Error>) -> Void) {
        return store.write(codable: rates.modified(),
                           encoder: CurrencyEncoder(),
                           completion: completion)
    }
}
