//
//  Number.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import Foundation
import SwiftUI

extension String {
    
    var number2f: Double { (Double(self) ?? 0) / 100 }
    
    var numberFormatted2f: LocalizedStringKey { "\(number2f, specifier: "%.2f")" }
}

extension Double {
    var formatted2f: LocalizedStringKey { "\(self, specifier: "%.2f")" }
}
