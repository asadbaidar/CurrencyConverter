//
//  CurrencyApiTests.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import XCTest
import Combine
@testable import CurrencyConverter

final class CurrencyApiTests: XCTestCase {
    private var mockHttpClient: HttpClientMock!
    private var sutCurrencyApi: CurrencyApi!
    
    private var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockHttpClient = HttpClientMock()
        sutCurrencyApi = ICurrencyApi(http: mockHttpClient)
        subscriptions = []
    }
    
    override func tearDown() {
        mockHttpClient = nil
        sutCurrencyApi = nil
        subscriptions = nil
        super.tearDown()
    }
    
    func testGetRates() throws {
        mockHttpClient.requestData = mockRateJson
        let expectation = XCTestExpectation(description: "Rate data is fetched from api")
        
        sutCurrencyApi.getRates()
            .sinkToResult { result in
                result.assertSuccess(value: mockRateModel, "Rate data is not as expected")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockHttpClient.didCallRequest, "No request call")
    }
}
