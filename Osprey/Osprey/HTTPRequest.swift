//
//  HTTPRequest.swift
//  Osprey
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Foundation

public struct HTTPMethod {
    
    public let rawValue: String
    
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
}

public struct HTTPRequest {
    
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = EmptyBody()
    
    private var urlComponents = URLComponents()
    
    public init() {
        urlComponents.scheme = "https"
    }
}

extension HTTPRequest {
    
    public var url: URL? { urlComponents.url }
    
    public var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }
    
    public var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
    
    public var parameters: [String: String] {
        get {
            guard let items = urlComponents.queryItems else {
                return [:]
            }
            var parametersDictionary: [String: String] = [:]
            for item in items {
                parametersDictionary[item.name] = item.value
            }
            return parametersDictionary
        }
        set {
            var queryItems: [URLQueryItem] = []
            for (name, value) in newValue {
                let item = URLQueryItem(name: name, value: value)
                queryItems.append(item)
            }
            urlComponents.queryItems = queryItems
        }
    }
}
