//
//  CurrencyBlocTests.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import XCTest
import Combine
@testable import CurrencyConverter
final class CurrencyBlocTests: XCTestCase {
    
    private var mockCurrencyRepository: CurrencyRepositoryMock!
    private var sutCurrencyBloc: CurrencyBloc!
    
    private var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockCurrencyRepository = CurrencyRepositoryMock()
        sutCurrencyBloc = CurrencyBloc(repository: mockCurrencyRepository)
        subscriptions = []
    }
    
    override func tearDown() {
        mockCurrencyRepository = nil
        sutCurrencyBloc = nil
        subscriptions = nil
        super.tearDown()
    }
    
    func testGetRates() throws {
        mockCurrencyRepository.getRatesResult = CurrentValueSubject(mockRateModel).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "load rate event should request data from repository")
        
        sutCurrencyBloc.$state
            .dropFirst(2)
            .map(\.apiState)
            .sink { state in
                XCTAssertEqual(state.status, .loaded, "State not loaded")
                XCTAssertEqual(state.data, mockRateModel, "State data not as expected")
                XCTAssertNil(state.error, "State has error")
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        
        sutCurrencyBloc.event = .loadRates
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockCurrencyRepository.didCallGetRates, "No rate request called")
    }
}
