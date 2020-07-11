//
//  HTTPLoading.swift
//  Osprey
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Foundation

public protocol HTTPLoading {
    
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
}

extension URLSession: HTTPLoading {
    
    public func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        
        // set the url for the request
        guard let url = request.url else {
            completion(.failure(HTTPError(code: .invalidURL, request: request)))
            return
        }
        var urlRequest = URLRequest(url: url)
        
        // set the method for the request
        urlRequest.httpMethod = request.method.rawValue
        
        // set the headers for the request
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        // set the body of the request
        if !request.body.isEmpty {
            
            // set additional headers based on the body type
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }
            
            // attempt to encode the body as Data
            do {
                urlRequest.httpBody = try request.body.encode()
            }
            catch (let encodingError) {
                completion(.failure(HTTPError(code: .invalidHTTPBody, request: request, underlyingError: encodingError)))
                return
            }
        }
        
        // send the request and create a result from whatever comes back
        let task = dataTask(with: urlRequest) { data, response, error in
            completion(HTTPResult(request: request, responseData: data, response: response, error: error))
        }
        task.resume()
    }
}
