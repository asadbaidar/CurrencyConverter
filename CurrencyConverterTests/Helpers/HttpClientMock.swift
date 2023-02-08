//
//  HttpClientMock.swift
//  CurrencyConverterTests
//
//  Created by Asad Baidar on 08/02/2023.
//

import Foundation
import Combine
@testable import CurrencyConverter

class HttpClientMock: HttpClient {
    let config: HttpConfig
    
    init(config: HttpConfig = HttpConfig(baseUrl: "", apiKey: [:])) {
        self.config = config
    }
    
    var requestData: Data?
    var didCallRequest = false
    
    func get<R: Codable>(
        baseUrl: String? = nil,
        path: String,
        query: JsonObject? = nil,
        headers: HttpHeaders? = nil,
        timeout: TimeInterval? = nil,
        decoder: JSONDecoder? = nil
    ) -> AnyPublisher<R, Error> {
        return request(
            baseUrl: baseUrl,
            path: path,
            method: HttpMethod.get,
            query: query,
            headers: headers,
            timeout: timeout,
            decoder: decoder
        )
    }
    
    func request<R: Codable>(
        baseUrl: String? = nil,
        path: String,
        method: HttpMethod,
        query:  JsonObject? = nil,
        body: JsonObject? = nil,
        headers: HttpHeaders? = nil,
        timeout: TimeInterval? = nil,
        decoder: JSONDecoder? = nil
    ) -> AnyPublisher<R, Error> {
        didCallRequest = true
        guard let codable = requestData?.toCodable(R.self, decoder: decoder) else {
            return Fail<R, Error>(error: HttpRequestError()).eraseToAnyPublisher()
        }
        return CurrentValueSubject(codable).eraseToAnyPublisher()
    }
}
