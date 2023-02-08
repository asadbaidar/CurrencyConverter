//
//  Extensions.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import XCTest
import Combine

extension Result where Success: Equatable {
    func assertSuccess(value: Success, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            XCTAssertEqual(resultValue, value, message(), file: file, line: line)
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}

extension Result where Success == Void {
    func assertSuccess(file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        case .success:
            break
        }
    }
}

extension Result {
    func assertFailure(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            XCTFail("Unexpected success: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                XCTAssertEqual(error.localizedDescription, message, file: file, line: line)
            }
        }
    }
}
