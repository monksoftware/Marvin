//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import XCTest
import Marvin

class ResultTests: XCTestCase {
    
    func testOk() {
        var resultOk: Result<Int, String>
        resultOk = .ok(1)
        XCTAssert(resultOk.isOk)
        XCTAssert(resultOk.ok == .some(1))
        XCTAssert(resultOk.map({ (value) -> String in String(value)}) == .ok("1"))
        XCTAssert(resultOk.mapErr({ (err) -> Int in err.count}).ok! == 1)
        
        
        let result1 = resultOk.flatMap({ (value: Int) -> Result<String, String> in
            Result.ok("ok")
        })
        XCTAssert(result1.ok! == "ok")
        
        
        let result2 = resultOk.flatMap({ (value: Int) -> Result<String, String> in
            Result.err("e")
        })
        XCTAssert(result2.err! == "e")
    }
    
    func testErr() {
        var resultErr: Result<Int32, String>
        resultErr = .err("error")
        XCTAssert(resultErr.isErr)
        XCTAssert(resultErr.err == .some("error"))
        XCTAssert(resultErr.map({ (value) -> String in String(value)}) == .err("error"))
        XCTAssert(resultErr.mapErr({ (err) -> Int in err.count}).err! == 5)
        
        
        let result1 = resultErr.flatMapErr({ (err: String) -> Result<Int32, Int> in
            Result.ok(1)
        })
        XCTAssert(result1.ok! == 1)

        let result2 = resultErr.flatMapErr({ (err: String) -> Result<Int32, Int> in
            Result.err(1)
        })
        XCTAssert(result2.err! == 1)
    }
}
