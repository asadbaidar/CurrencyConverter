//
//  CurrencyBloc.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation
import Combine

class CurrencyBloc: ObservableObject {
    private let repository: CurrencyRepository
    
    init(repository: CurrencyRepository = ICurrencyRepository()) {
        self.repository = repository
        debugPrint("CurrencyBloc init")
    }
    
    private var cancellable: Set<AnyCancellable> = []
    
    @Published var state = CurrencyState()
    
    var event: CurrencyRateEvent? {
        didSet {
            self.handleEvent(event)
        }
    }
    
    private func handleEvent(_ event: CurrencyRateEvent?) {
        switch event {
        case .loadRates:
            getRates()
        case .none:
            debugPrint("not an event")
        }
    }
}

extension CurrencyBloc {
    
    private func getRates() {
        state.apiState = .init(status: .loading)
        repository.getRates()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.state.apiState = .init(status: .failure, error: error.localizedDescription)
                }
            }, receiveValue: { data in
                if(data.rates.isEmpty) {
                    self.state.apiState = .init(status: .loading)
                } else {
                    self.state.apiState = .init(status: .loaded, data: data)
                }
            })
            .store(in: &cancellable)
    }
}
