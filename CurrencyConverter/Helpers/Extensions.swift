//
//  Extensions.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 07/02/2023.
//

import Foundation
import SwiftUI
import Combine

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

typealias VoidCallback = () -> Void

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Self.Output, Self.Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
}

public extension Dictionary {
    
    mutating func mergeNew(with other: Dictionary?) {
        if let other = other {
            merge(other) { (_, new) in new }
        }
    }
    
    func mergingNew(with other: Dictionary?) -> Dictionary {
        if let other = other {
            return merging(other) { (_, new) in new }
        }
        return self
    }
}
