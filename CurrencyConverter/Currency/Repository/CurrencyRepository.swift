//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation
import Combine

protocol CurrencyRepository {
    
    func getRates() -> AnyPublisher<CurrencyRateData, Error>
}

class ICurrencyRepository : CurrencyRepository {
    let api: CurrencyApi
    let store: CurrencyStore
    
    init(api: CurrencyApi = ICurrencyApi(),
         store: CurrencyStore = ICurrencyStore()) {
        self.api = api
        self.store = store
    }
    
    private var cancellable: Set<AnyCancellable> = []
    
    /// if store data is older than 30 minutes,
    /// get from API otherwise use the store data
    func getRates() -> AnyPublisher<CurrencyRateData, Error> {
        let subject = CurrentValueSubject<CurrencyRateData, Error>(CurrencyRateData())
        /// Get from API and save it to store file
        func getFromApi() {
            api.getRates()
                .tryMap({ rates in
                    self.store.saveRates(rates)
                    return rates
                })
                .subscribe(subject)
                .store(in: &cancellable)
        }
        // checking store data
        store.getRates { completion in
            switch completion {
            case .success(let rates):
                if (rates.isOlderThanHalfHour) {
                    getFromApi()
                } else {
                    subject.send(rates)
                }
            case .failure(_):
                getFromApi()
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
