//
//  HttpClient.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 04/02/2023.
//

import Foundation
import Combine

public typealias JsonObject = [String : Any?]
public typealias JsonArray = [Any]
public typealias HttpHeaders = [String : String]

struct HttpConfig {
    public var baseUrl: String
    public var apiKey: JsonObject
    public var session: URLSession = URLSession.shared
    public var headers: HttpHeaders?
    public var timeout: TimeInterval = 60.0
}

enum HttpMethod: String {
    case get
    case post
    case put
    case delete
    case patch
    
    public var value: String { rawValue.uppercased() }
}

protocol HttpClient {
    var config: HttpConfig { get }
    
    func get<R: Codable>(
        baseUrl: String?,
        path: String,
        query: JsonObject?,
        headers: HttpHeaders?,
        timeout: TimeInterval?,
        decoder: JSONDecoder?
    ) -> AnyPublisher<R, Error>
    
    func request<R: Codable>(
        baseUrl: String?,
        path: String,
        method: HttpMethod,
        query:  JsonObject?,
        body: JsonObject?,
        headers: HttpHeaders?,
        timeout: TimeInterval?,
        decoder: JSONDecoder?
    ) -> AnyPublisher<R, Error>
}

extension HttpClient {
    
    func get<R: Codable>(
        baseUrl: String? = nil,
        path: String,
        query: JsonObject? = nil,
        headers: HttpHeaders? = nil,
        timeout: TimeInterval? = nil,
        decoder: JSONDecoder? = nil
    ) -> AnyPublisher<R, Error> {
        return get(
            baseUrl: baseUrl,
            path: path,
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
        return request(
            baseUrl: baseUrl,
            path: path,
            method: method,
            query: query,
            body: body,
            headers: headers,
            timeout: timeout,
            decoder: decoder
        )
    }
}

class IHttpClient: HttpClient {
    let config: HttpConfig
    
    init(config: HttpConfig) {
        self.config = config
    }
    
    func get<R: Codable>(
        baseUrl: String?,
        path: String,
        query: JsonObject?,
        headers: HttpHeaders?,
        timeout: TimeInterval?,
        decoder: JSONDecoder?
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
        baseUrl: String?,
        path: String,
        method: HttpMethod,
        query:  JsonObject?,
        body: JsonObject?,
        headers: HttpHeaders?,
        timeout: TimeInterval?,
        decoder: JSONDecoder?
    ) -> AnyPublisher<R, Error> {
        do {
            let request = try IHttpClient.createRequest(
                baseUrl: baseUrl ?? config.baseUrl,
                path: path,
                method: method,
                query: config.apiKey.mergingNew(with: query),
                body: body,
                headers: headers ?? config.headers,
                timeout: timeout ?? config.timeout
            )
            return URLSession.DataTaskPublisher(
                request: request,
                session: config.session
            )
            .tryMap { data, response  in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HttpRequestError()
                }
                
                guard IHttpClient.httpSuccess.contains(httpResponse.statusCode) else {
                    if let error = data.toCodable(HttpRequestError.self) {
                        throw error
                    }
                    else if IHttpClient.httpUnauthrized.contains(httpResponse.statusCode) {
                        throw HttpUnauthrizedError()
                    } else {
                        throw HttpRequestError(status: httpResponse.statusCode)
                    }
                }
                guard let codeable = data.toCodable(R.self, decoder: decoder) else {
                    throw HttpRequestError()
                }
                return codeable
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
        catch {
            return Fail<R, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    static public func createRequest(
        baseUrl: String,
        path: String,
        method: HttpMethod,
        query: JsonObject? = nil,
        body: JsonObject? = nil,
        headers: HttpHeaders? = nil,
        timeout: TimeInterval = 60.0
    ) throws -> URLRequest {
        
        var urlComponents = URLComponents(string: baseUrl + path)
        
        if let queryItems = query?.queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else { throw HttpRequestError.invalidURL }
        
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method.value
        
        if let httpHeaders = headers {
            request.allHTTPHeaderFields = httpHeaders
        }
        if let httpBody = body?.data {
            request.httpBody = httpBody
        }
        
        debugPrint(url)
        return request
    }
    
    static let httpSuccess = 200..<300;
    static let httpUnauthrized = [401, 403];
}

struct HttpUnauthrizedError: CustomError {
    var status: Int? = nil
    var message: String = "unauthrized"
    var description: String = "Access Denied"
}

struct HttpRequestError: CustomError {
    var status: Int? = nil
    var message: String = "invalid_request"
    var description: String = "Invlid Request"
}

extension HttpRequestError {
    static let invalidURL = HttpRequestError(message: "Invalid URL")
}

extension Dictionary where Key == String, Value == Any? {
    
    public var queryItems: [URLQueryItem] {
        return self.map { (parameter) -> URLQueryItem in
            URLQueryItem(name: parameter.key, value: (parameter.value as? AnyObject)?.description)
        }
    }
}
