//
//  StoreClientMock.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import Foundation
import Combine
@testable import CurrencyConverter

class StoreClientMock: StoreClient {
    let config: StoreConfig
    
    init(config: StoreConfig = StoreConfig()) {
        self.config = config
    }
    
    var storeFile: Data?
    var didCallRead = false
    var didCallWrite = false
    
    func read<R: Codable>(
        from fileName: String? = nil,
        decoder: JSONDecoder? = nil,
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        didCallRead = true
        guard let file = storeFile else {
            completion(.failure(StoreError.fileNotFound))
            return
        }
        guard let codable = file.toCodable(R.self, decoder: decoder) else {
            completion(.failure(StoreError.parsingError))
           return
        }
        completion(.success(codable))
    }
    
    func write(
        codable: Codable,
        to fileName: String? = nil,
        encoder: JSONEncoder? = nil,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        didCallWrite = true
        guard let data = codable.toData(encoder: encoder) else {
            completion(.failure(StoreError.parsingError))
           return
        }
        storeFile = data
        completion(.success(true))
    }
    
    func read<R : Codable>(
        from fileName: String? = nil,
        decoder: JSONDecoder? = nil
    ) -> AnyPublisher<R, Error> {
        didCallRead = true
        guard let file = storeFile else {
            return Fail<R, Error>(error: StoreError.fileNotFound).eraseToAnyPublisher()
        }
        guard let codable = file.toCodable(R.self, decoder: decoder) else {
            return Fail<R, Error>(error: StoreError.parsingError).eraseToAnyPublisher()
        }
        return CurrentValueSubject(codable).eraseToAnyPublisher()
    }
    
    func write(
        codable: Codable,
        to fileName: String? = nil,
        encoder: JSONEncoder? = nil
    ) -> AnyPublisher<Bool, Error> {
        didCallWrite = true
        guard let data = codable.toData(encoder: encoder) else {
            return Fail<Bool, Error>(error: StoreError.parsingError).eraseToAnyPublisher()
        }
        storeFile = data
        return CurrentValueSubject(true).eraseToAnyPublisher()
    }

}
