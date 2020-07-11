//
//  HTTPError.swift
//  Osprey
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Foundation

public struct HTTPError: Error {
    
    let code: Code
    let request: HTTPRequest
    let response: HTTPResponse?
    let underlyingError: Error?
    
    enum Code {
        case canceled
        case invalidHTTPBody
        case invalidResponse
        case invalidURL
        case other(URLError.Code)
        case unknown
    }
    
    init(code: Code, request: HTTPRequest,response: HTTPResponse? = nil, underlyingError: Error? = nil) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
}
