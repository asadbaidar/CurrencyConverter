//
//  Codable.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import Foundation

extension Dictionary where Key == String, Value == Any? {

    public var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
}

extension Encodable {
    
    public func toData(encoder: JSONEncoder? = nil) -> Data? {
        return try? (encoder ?? JSONEncoder()).encode(self)
    }
}

extension Data {
    
    public func toCodable<T: Codable>(_ type: T.Type, decoder: JSONDecoder? = nil) -> T? {
        return try? (decoder ?? JSONDecoder()).decode(type, from: self)
    }
    
    public var json: Any? {
        return try? JSONSerialization.jsonObject(with: self)
    }
    
    public var jsonObject: JsonObject? {
        return json as? JsonObject
    }
    
    public var jsonArray: JsonArray? {
        return json as? JsonArray
    }
}
