//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public struct Network {
    
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public enum Mode {
        case sync
        case async(responseQueue: DispatchQueue)
    }
    
    public static func execute<T>(mode: Mode,
                                  request: NetworkRequestWithCustomResponse<T>,
                                  response: @escaping (Result<T, NetworkError>) -> ()) {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Data, Error>?
        
        func handler() {
            switch result! {
            case .ok(let jsonData):
                switch T.make(jsonData: jsonData) {
                case .ok(let result):
                    response(.ok(result))
                case .err(let e):
                    response(.err(.parseJSONError(e, data: jsonData)))
                }
                
            case .err(let e):
                response(.err(.networkError(e)))
                
            }
        }
        
        Network.request(url: request.path,
                            method: request.method,
                            headers: request.headers,
                            body: request.bodyAsJSON,
                            queryString: request.queryString)
        {
            result  = $0
            switch mode {
            case .sync:
                semaphore.signal()
            case .async(let queue):
                queue.async(execute: handler)
            }
        }
        
        if case .sync = mode {
            semaphore.wait()
            handler()
        }
        
    }
    
    public static func execute<T>(mode: Mode,
                                  request: NetworkRequest<T>,
                                  response: @escaping (Result<T, NetworkError>) -> ()) {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Data, Error>?
        
        func handler() {
            switch result! {
            case .ok(let jsonData):
                do {
                    let value = try JSONDecoder().decode(T.self, from: jsonData)
                    response(.ok(value))
                } catch {
                    response(.err(.parseJSONError(error, data: jsonData)))
                }
                
            case .err(let e):
                response(.err(.networkError(e)))
            }
        }
        
        Network.request(url: request.path,
                            method: request.method,
                            headers: request.headers,
                            body: request.bodyAsJSON,
                            queryString: request.queryString)
        {
            result  = $0
            switch mode {
            case .sync:
                semaphore.signal()
            case .async(let queue):
                queue.async(execute: handler)
            }
        }
        
        if case .sync = mode {
            semaphore.wait()
            handler()
        }
        
    }
    
    private static func request(url: URL,
                                method: Network.Method,
                                headers: [String: String]? = nil,
                                body: Data? = nil,
                                queryString: [String: String]? = nil,
                                handler: @escaping (Result<Data, Error>) -> Void) {
        
        
        
        var request = URLRequest(url: url)
        
        // Method
        request.httpMethod = method.rawValue
        
        // QueryString
        if let queryString = queryString {
            request.url = URL(string: url.absoluteString + buildQueryString(fromDictionary: queryString))
        }
        
        // Headers
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        // Body
        request.httpBody = body
        
        
        // Result
        URLSession.shared.dataTask(with: request) { data, response, error in
            //            if let httpResponse = response as? HTTPURLResponse {
            //                httpResponse.statusCode
            //            }
            if let data = data {
                handler(.ok(data))
            } else {
                handler(.err(error!))
            }
            }.resume()
    }
    
    private static func buildQueryString(fromDictionary parameters: [String: String]) -> String {
        let urlVars = parameters.compactMap { key, value in
            value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).map {
                key + "=" + $0
            }
        }
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
}
