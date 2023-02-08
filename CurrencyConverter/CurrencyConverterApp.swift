//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 04/02/2023.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            if(!isUnitTest) {
                CurrencyPageView()
            }
        }
    }
}

var isUnitTest: Bool {  NSClassFromString("XCTest") != nil }
