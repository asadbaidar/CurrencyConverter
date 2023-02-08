//
//  StoreClient.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import Foundation
import Combine

struct StoreConfig {
    let fileName: String = "store.data"
}

protocol StoreClient {
    var config: StoreConfig { get }
    
    func read<R: Codable>(
        from fileName: String?,
        decoder: JSONDecoder?,
        completion: @escaping (Result<R, Error>) -> Void
    )
    
    func write(
        codable: Codable,
        to fileName: String?,
        encoder: JSONEncoder?,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    func read<R : Codable>(
        from fileName: String?,
        decoder: JSONDecoder?
    ) -> AnyPublisher<R, Error>
    
    func write(
        codable: Codable,
        to fileName: String?,
        encoder: JSONEncoder?
    ) -> AnyPublisher<Bool, Error>
}

extension StoreClient {
    
    func read<R: Codable>(
        from fileName: String? = nil,
        decoder: JSONDecoder? = nil,
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        read(from: fileName,
             decoder: decoder,
             completion: completion)
    }
    
    func write(
        codable: Codable,
        to fileName: String? = nil,
        encoder: JSONEncoder? = nil,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        write(codable: codable,
              to: fileName,
              encoder: encoder,
              completion: completion)
    }
    
    func read<R : Codable>(
        from fileName: String? = nil,
        decoder: JSONDecoder? = nil
    ) -> AnyPublisher<R, Error> {
        return read(from: fileName,
                    decoder: decoder)
    }
    
    func write(
        codable: Codable,
        to fileName: String? = nil,
        encoder: JSONEncoder? = nil
    ) -> AnyPublisher<Bool, Error> {
        return write(codable: codable,
                     to: fileName,
                     encoder: encoder)
    }
}

class IStoreClient: StoreClient {
    let config: StoreConfig
    
    init(config: StoreConfig = StoreConfig()) {
        self.config = config
    }
    
    func read<R: Codable>(
        from fileName: String? = nil,
        decoder: JSONDecoder? = nil,
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        let fileName = fileName ?? config.fileName
        debugPrint("read", fileName)
        DispatchQueue.global(qos: .background).async {
            do {
                let url = try IStoreClient.urlForFile(name: fileName)
                guard let file = try? FileHandle(forReadingFrom: url) else {
                    DispatchQueue.main.async {
                        completion(.failure(StoreError.fileNotFound))
                    }
                    return
                }
                guard let data = file.availableData.toCodable(R.self, decoder: decoder) else {
                    DispatchQueue.main.async {
                        completion(.failure(StoreError.parsingError))
                    }
                    return
                }
                debugPrint("read", data)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StoreError(description: error.localizedDescription)))
                }
            }
        }
    }
    
    func write(
        codable: Codable,
        to fileName: String? = nil,
        encoder: JSONEncoder? = nil,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let fileName = fileName ?? config.fileName
        debugPrint("write", fileName)
        DispatchQueue.global(qos: .background).async {
            do {
                let url = try IStoreClient.urlForFile(name: fileName)
                
                guard let data = codable.toData(encoder: encoder) else {
                    DispatchQueue.main.async {
                        completion(.failure(StoreError.parsingError))
                    }
                    return
                }
                do {
                    try data.write(to: url)
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(StoreError.writingError))
                    }
                    return
                }
                
                debugPrint("write", data)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StoreError(description: error.localizedDescription)))
                }
            }
        }
    }
    
    func read<R : Codable>(
        from fileName: String? = nil,
        decoder: JSONDecoder? = nil
    ) -> AnyPublisher<R, Error> {
        let fileName = fileName ?? config.fileName
        debugPrint("read", fileName)
        do {
            return Just(try IStoreClient.urlForFile(name: fileName))
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { url in
                    guard let file = try? FileHandle(forReadingFrom: url) else {
                        throw StoreError.fileNotFound
                    }
                    guard let data = file.availableData.toCodable(R.self, decoder: decoder) else {
                        throw StoreError.parsingError
                    }
                    debugPrint("read", data)
                    return data
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        catch {
            return Fail<R, Error>(
                error: StoreError(description: error.localizedDescription)
            ).eraseToAnyPublisher()
        }
    }
    
    func write(
        codable: Codable,
        to fileName: String? = nil,
        encoder: JSONEncoder? = nil
    ) -> AnyPublisher<Bool, Error> {
        let fileName = fileName ?? config.fileName
        debugPrint("write", fileName)
        do {
            return Just(try IStoreClient.urlForFile(name: fileName))
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { url in
                    guard let data = codable.toData(encoder: encoder) else {
                        throw StoreError.parsingError
                    }
                    do {
                        try data.write(to: url)
                    } catch {
                        throw StoreError.writingError
                    }
                    debugPrint("write", url)
                    return true
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        catch {
            return Fail<Bool, Error>(
                error: StoreError(description: error.localizedDescription)
            ).eraseToAnyPublisher()
        }
    }
    
    private static func urlForFile(name: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent(name)
    }
}

struct StoreError: CustomError {
    var status: Int? = nil
    var message: String = "no_or_invalid_file"
    var description: String = "Unable to access store file"
}

extension StoreError {
    static let parsingError = StoreError(description: "Error while parsing data")
    static let writingError = StoreError(description: "Error while writing data to store file")
    static let fileNotFound = StoreError(description: "No file exist")
}
