//
//  ApiState.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 07/02/2023.
//

import Foundation

enum ApiStatus {
    case initial
    case loading
    case loaded
    case failure
}

struct ApiState<T: Equatable>: Equatable {
    public let status: ApiStatus
    public let data: T?
    public let error: String?
    
    init(status: ApiStatus = .initial, data: T? = nil, error: String? = nil) {
        self.status = status
        self.data = data
        self.error = error
    }
    
    var errorMessage: String { status == .failure ? error ?? "Something went wrong" : "" }
}
