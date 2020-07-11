//
//  HTTPResult.swift
//  Osprey
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Foundation

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    
    var request: HTTPRequest {
        switch self {
        case .success(let response):
            return response.request
        case .failure(let error):
            return error.request
        }
    }
    
    var response: HTTPResponse? {
        switch self {
        case .success(let response):
            return response
        case .failure(let error):
            return error.response
        }
    }
    
    init(request: HTTPRequest, responseData: Data?, response: URLResponse?, error: Error?) {
        
        var httpResponse: HTTPResponse?
        if let httpURLResponse = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, underlyingResponse: httpURLResponse, body: responseData)
        }

        if let urlError = error as? URLError {
            let code: HTTPError.Code
            switch urlError.code {
            case .badURL:
                code = .invalidURL
            case .cancelled:
                code = .canceled
            default:
                code = .other(urlError.code)
            }
            self = .failure(HTTPError(code: code, request: request, response: httpResponse, underlyingError: urlError))
        }
        else if let otherError = error {
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: otherError))
        }
        else if let httpResponse = httpResponse {
            self = .success(httpResponse)
        }
        else {
            self = .failure(HTTPError(code: .invalidResponse, request: request, response: nil, underlyingError: nil))
        }
    }
}
