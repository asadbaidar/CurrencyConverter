//
//  CurrencyRateMock.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import Foundation
@testable import CurrencyConverter

let mockRateModel = CurrencyRateData(timestamp: Date(timeIntervalSince1970: 1675811675),
                                 base: "USD",
                                 rates: ["USD": 1.0, "PKR": 277.5])

let mockRateJson = """
{
"timestamp": 1675811675,
"base": "USD",
"rates": {"USD": 1.0, "PKR": 277.5}
}
""".data(using: .utf8)!
