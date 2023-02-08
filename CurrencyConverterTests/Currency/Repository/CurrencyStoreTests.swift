//
//  CurrencyStoreTests.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyStoreTests: XCTestCase {
    private var mockStoreClient: StoreClientMock!
    private var sutCurrencyStore: CurrencyStore!
    
    override func setUp() {
        super.setUp()
        mockStoreClient = StoreClientMock()
        sutCurrencyStore = ICurrencyStore(store: mockStoreClient)
    }
    
    override func tearDown() {
        mockStoreClient = nil
        sutCurrencyStore = nil
        super.tearDown()
    }
    
    func testGetRates() throws {
        mockStoreClient.storeFile = mockRateJson
        let expectation = XCTestExpectation(description: "Rate is read from store file")
        
        sutCurrencyStore.getRates() { result in
            result.assertSuccess(value: mockRateModel, "Rate data is not as expected")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockStoreClient.didCallRead, "No read call")
    }
    
    func testSaveRates() throws {
        let expectation = XCTestExpectation(description: "Rate is saved to store file")
        
        sutCurrencyStore.saveRates(mockRateModel) { result in
            result.assertSuccess(value: true, "Saving Rate data failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(mockStoreClient.storeFile, "Store file is empty")
        XCTAssertTrue(mockStoreClient.didCallWrite, "No write call")
    }
}

