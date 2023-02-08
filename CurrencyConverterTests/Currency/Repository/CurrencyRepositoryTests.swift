//
//  CurrencyRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import XCTest
import Combine
@testable import CurrencyConverter

final class CurrencyRepositoryTests: XCTestCase {
    private var mockHttpClient: HttpClientMock!
    private var mockStoreClient: StoreClientMock!
    private var currencyApi: CurrencyApi!
    private var currencyStore: CurrencyStore!
    private var sutCurrencyRepository: CurrencyRepository!
    
    private var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockHttpClient = HttpClientMock()
        mockStoreClient = StoreClientMock()
        currencyApi = ICurrencyApi(http: mockHttpClient)
        currencyStore = ICurrencyStore(store: mockStoreClient)
        sutCurrencyRepository = ICurrencyRepository(api: currencyApi,
                                                    store: currencyStore)
        subscriptions = []
    }
    
    override func tearDown() {
        mockHttpClient = nil
        mockStoreClient = nil
        currencyApi = nil
        currencyStore = nil
        sutCurrencyRepository = nil
        subscriptions = nil
        super.tearDown()
    }
    
    func testShouldGetRatesFromStoreIfItHasLatestTimestamp() throws {
        let timestamp = Date.now.timeIntervalSince1970
        let newRateJson = mockRateJson.withTimestamp(timestamp)
        let newRateModel = mockRateModel.withTimestamp(timestamp)
        mockHttpClient.requestData = newRateJson
        mockStoreClient.storeFile = newRateJson
        
        let expectation = XCTestExpectation(description: "test should get rates from store if it has latest timestamp")
        
        sutCurrencyRepository.getRates()
            .sinkToResult { result in
                result.assertSuccess(value: newRateModel, "Rate data is not as expected")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertFalse(mockHttpClient.didCallRequest, "Http request called")
        XCTAssertFalse(mockStoreClient.didCallWrite, "Store write called")
        XCTAssertTrue(mockStoreClient.didCallRead, "Store read not called")
    }
    
    func testShouldGetRatesFromHttpIfStoreHasOldTimestamp() throws {
        let timestamp = Date.now.timeIntervalSince1970
        let oldRateJson = mockRateJson
        let newRateJson = mockRateJson.withTimestamp(timestamp)
        let newRateModel = mockRateModel.withTimestamp(timestamp)
        mockHttpClient.requestData = newRateJson
        mockStoreClient.storeFile = oldRateJson
        
        let expectation = XCTestExpectation(description: "test should get rates from http if store has old timestamp")
        
        sutCurrencyRepository.getRates()
            .sinkToResult { result in
                result.assertSuccess(value: newRateModel, "Rate data is not as expected")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockHttpClient.didCallRequest, "Http request not called")
        XCTAssertTrue(mockStoreClient.didCallWrite, "Store write not called")
        XCTAssertTrue(mockStoreClient.didCallRead, "Store read not called")
    }
}

private extension Data {
    
    func withTimestamp(_ timestamp: Double) -> Data {
        var json = mockRateJson.jsonObject!
        json["timestamp"] = timestamp
        return json.data!
    }
}

private extension CurrencyRateData {
    
    func withTimestamp(_ timestamp: Double) -> CurrencyRateData {
        copyWith(timestamp: Date(timeIntervalSince1970: timestamp))
    }
}
