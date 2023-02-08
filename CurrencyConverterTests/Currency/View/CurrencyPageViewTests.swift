//
//  CurrencyPageViewTests.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import XCTest
import Combine
import SwiftUI
@testable import CurrencyConverter
import ViewInspector

final class CurrencyPageViewTests: XCTestCase {
    
    private var mockCurrencyRepository: CurrencyRepositoryMock!
    private var currencyBloc: CurrencyBloc!
    private var sutView: CurrencyPageView!
        
    override func setUp() {
        super.setUp()
        mockCurrencyRepository = CurrencyRepositoryMock()
        mockCurrencyRepository.getRatesResult = CurrentValueSubject(mockRateModel).eraseToAnyPublisher()
        currencyBloc = CurrencyBloc(repository: mockCurrencyRepository)
        sutView = CurrencyPageView(bloc: self.currencyBloc)
    }
    
    override func tearDown() {
        mockCurrencyRepository = nil
        currencyBloc = nil
        sutView = nil
        super.tearDown()
    }
    
    func testCurrencyMenuShouldRenderAlways() throws {
        XCTAssertNoThrow(
            try sutView.inspect().find(CurrencyMenu.self),
            "CurrencyMenu should render always"
        )
    }
    
    func testAmountInputFieldShouldRenderAlways() throws {
        XCTAssertNoThrow(
            try sutView.inspect().find(AmountInputField.self),
            "AmountInputField should render always"
        )
    }
    
    func testLoadingStateShouldRenderProgressView() throws {
        currencyBloc.state.apiState = .init(status: .loading)
        
        try testCurrencyMenuShouldRenderAlways()
        try testAmountInputFieldShouldRenderAlways()
        
        XCTAssertNoThrow(
            try sutView.inspect().find(ViewType.ProgressView.self),
            "Loading state should render ProgressView"
        )
    }
    
    func testLoadedStateShouldRenderListView() throws {
        currencyBloc.state.apiState = .init(status: .loaded)
        
        try testCurrencyMenuShouldRenderAlways()
        try testAmountInputFieldShouldRenderAlways()
        
        XCTAssertNoThrow(
            try sutView.inspect().find(CurrencyListView.self),
            "Loaded state should render CurrencyListView"
        )
    }
    
    func testFailureStateShouldRenderErrorView() throws {
        currencyBloc.state.apiState = .init(status: .failure)
        
        try testCurrencyMenuShouldRenderAlways()
        try testAmountInputFieldShouldRenderAlways()
        
        XCTAssertNoThrow(
            try sutView.inspect().find(CurrencyErrorView.self),
            "Failure state should render CurrencyErrorView"
        )
    }
}
