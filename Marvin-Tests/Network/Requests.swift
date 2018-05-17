//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation
import Marvin

enum Requests {
    static let endpoint = URL(string: "https://jsonplaceholder.typicode.com")!
    
    struct Empty: Codable {
        
    }
    
    static func testGet(id: Int) -> NetworkRequest<Item> {
        return NetworkRequest(path: endpoint + "posts/\(id)",
                               method: .get,
                               response: Item.self)
    }
    
    static func testDelete(item: Item) -> NetworkRequest<Empty> {
        let path = endpoint + "posts\(item.userId)"
        let body = try! JSONEncoder().encode(item)
        return NetworkRequest(path: path,
                              method: .delete,
                              headers: nil,
                              bodyAsJSON: body,
                              queryString: nil,
                              response: Empty.self)
    
    }
    
    static func testGetCustom(id: Int) -> NetworkRequestWithCustomResponse<CustomTestGetResponse> {
        return NetworkRequestWithCustomResponse(path: endpoint + "posts/\(id)",
                                                 method: .get,
                                                 headers: nil,
                                                 bodyAsJSON: nil,
                                                 queryString: nil,
                                                 response: CustomTestGetResponse.self)
    }

}


struct Item: Codable {
    let userId: Int
    let title: String
    let body: String
}


struct CustomTestGetResponse: Response {
    
    let item: Item
    
    static func make(jsonData: Data) -> ErrorResult<CustomTestGetResponse> {
        return CustomTestGetResponse.decode {
            let item = try $0.decode(Item.self, from: jsonData)
            return CustomTestGetResponse(item: item)
        }
    }
}
