//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public struct NetworkRequest<T> where T: Decodable  {
    let path: URL
    let method: Network.Method
    let headers: [String: String]?
    let bodyAsJSON: Data?
    let queryString: [String: String]?
    let response: T.Type
    
    public init(path: URL,
         method: Network.Method,
         headers: [String: String]? = nil,
         bodyAsJSON: Data? = nil,
         queryString: [String: String]? = nil,
         response: T.Type) {
        self.path = path
        self.method = method
        self.headers = headers
        self.bodyAsJSON = bodyAsJSON
        self.queryString = queryString
        self.response = response
    }
}

public struct NetworkRequestWithCustomResponse<T: Response> {
    let path: URL
    let method: Network.Method
    let headers: [String: String]?
    let bodyAsJSON: Data?
    let queryString: [String: String]?
    let response: T.Type
    
    public init(path: URL,
                method: Network.Method,
                headers: [String: String]? = nil,
                bodyAsJSON: Data? = nil,
                queryString: [String: String]? = nil,
                response: T.Type) {
        self.path = path
        self.method = method
        self.headers = headers
        self.bodyAsJSON = bodyAsJSON
        self.queryString = queryString
        self.response = response
    }
}













