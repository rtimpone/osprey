//
//  HTTPBody.swift
//  Osprey
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Foundation

public protocol HTTPBody {
    
    var isEmpty: Bool { get }
    var additionalHeaders: [String: String] { get }
    func encode() throws -> Data
}

struct EmptyBody: HTTPBody {
    
    let isEmpty = true
    let additionalHeaders: [String: String] = [:]
    
    func encode() throws -> Data {
        return Data()
    }
}

struct DataBody: HTTPBody {
    
    var isEmpty: Bool { data.isEmpty }
    var additionalHeaders: [String : String]
    
    let data: Data
    
    init(_ data: Data, additionalHeaders: [String: String] = [:]) {
        self.data = data
        self.additionalHeaders = additionalHeaders
    }
    
    func encode() throws -> Data {
        return data
    }
}

struct JSONBody: HTTPBody {
    
    let isEmpty: Bool = false
    var additionalHeaders = ["Content-Type": "application/json; charset=utf-8"]
    
    private let encodeClosure: () throws -> Data
    
    init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        encodeClosure = { try encoder.encode(value) }
    }
    
    func encode() throws -> Data {
        return try encodeClosure()
    }
}

struct FormBody: HTTPBody {
    
    var isEmpty: Bool { values.isEmpty }
    var additionalHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    
    let values: [URLQueryItem]
    
    init(_ values: [URLQueryItem]) {
        self.values = values
    }
    
    init(_ values: [String: String]) {
        let queryItems = values.map { URLQueryItem(name: $0.key, value: $0.value) }
        self.init(queryItems)
    }
    
    func encode() throws -> Data {
        let pieces = values.map { urlEncode($0) }
        let bodyString = pieces.joined(separator: "&")
        return Data(bodyString.utf8)
    }
}

private extension FormBody {
    
    func urlEncode(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
    
    func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }
}
