//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import XCTest
import Marvin

class CustomResultTests: XCTestCase {
    
    func testErrorResult() {
        typealias ErrorResult<T> = Result<T, Error>
        
        let error1: ErrorResult<Int> = .ok(10)
        XCTAssert(error1.isOk)
        let error2: ErrorResult<Int> = .err(GenericError(description: ""))
        XCTAssert(error2.isErr)
    }
    
    func testNetworkResult() {
        enum NetworkError: Error, LocalizedError {
            case ko
            public var errorDescription: String? { return ""}
        }
        
        typealias NetworkResult<T> = Result<T, NetworkError>
        
        let error1: NetworkResult<Int> = .ok(10)
        XCTAssert(error1.isOk)
        let error2: NetworkResult<Int> = .err(.ko)
        XCTAssert(error2.isErr)
    }
    
}
