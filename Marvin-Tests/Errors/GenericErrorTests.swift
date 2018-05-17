//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import XCTest
import Marvin

class GenericErrorTests: XCTestCase {
    
    func testExample() {
        let e: Error = GenericError(description: "test")
        XCTAssertEqual(e.localizedDescription, "test")
    }
    
}
