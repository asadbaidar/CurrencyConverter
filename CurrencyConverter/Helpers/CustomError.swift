//
//  CustomError.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import Foundation

protocol CustomError: Codable, Error, Equatable {
    var status: Int? { get }
    var message: String { get }
    var description: String { get }
}

extension CustomError {
    var localizedDescription: String {
        "\(status?.description ?? "") \(description)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Error {
    var localizedDescription: String { (self as? (any CustomError))?.localizedDescription ?? "\(self)" }
}
