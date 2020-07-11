//
//  HTTPResponse.swift
//  Osprey
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Foundation

struct HTTPStatus {
    
    let rawValue: Int
}

public struct HTTPResponse {
    
    let request: HTTPRequest
    let underlyingResponse: HTTPURLResponse
    let body: Data?
    
    var status: HTTPStatus { HTTPStatus(rawValue: underlyingResponse.statusCode) }
    var message: String { HTTPURLResponse.localizedString(forStatusCode: underlyingResponse.statusCode) }
    var headers: [AnyHashable: Any] { underlyingResponse.allHeaderFields }
}
