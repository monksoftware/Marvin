//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import XCTest
import Marvin

private let test_fail_maxRetry = 2
private var test_fail_counterRetry = 0
private var test_retrayInfinityCount = 0
private var test_successAsyncCount = 0
private let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)

class PersistentOperations: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let fm = FileManager.default
        try? fm.removeItem(at: path)
        try! fm.createDirectory(at: path, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        super.tearDown()
        let fm = FileManager.default
        try? fm.removeItem(at: path)
    }
    
    func test_fail() {
        // Init
        test_fail_counterRetry = 0;
        
        // Operation
        class FailOperation: PersistentSyncOperation {
            var tryCount: Int?
            
            
            static var type: String = "FailOperation"
            func main() -> Bool {
                test_fail_counterRetry += 1;
                XCTAssert(test_fail_counterRetry <= test_fail_maxRetry)
                return false
            }
        }
        
        // Expectation
        let exp = expectation(description: "test_fail")
        
        // Logic
        let persistentQueue = PersistentOperationQueue(path: path,
                                                       operationsTypes: [FailOperation.self],
                                                       tryCount: test_fail_maxRetry)
        persistentQueue.didReachedTryCountCallBack = { op in
            XCTAssert(test_fail_counterRetry == test_fail_maxRetry)
        }
        
        persistentQueue.emptyCallBack = {
            exp.fulfill()
        }
        
        let added = persistentQueue.add(FailOperation())
        XCTAssert(added)
        
        // Waitw for expectations
        waitForExpectations(timeout: 30) { error in
            XCTAssert(error == nil)
        }
    }

    func test_success() {
        
        // Operation
        
        struct SuccessOperation: PersistentSyncOperation {
            static var type: String = "SuccessOperation"
            
            func main() -> Bool {
                return true
            }
        }
        
        // Expectation
        let exp = expectation(description: "test_success")
        
        // Logic
        let persistentQueue = PersistentOperationQueue(path: path,
                                                       operationsTypes: [SuccessOperation.self],
                                                       tryCount: 1)
        persistentQueue.didReachedTryCountCallBack = { op in
            XCTFail()
        }
        
        persistentQueue.emptyCallBack = {
            exp.fulfill()
        }
        
        XCTAssert(persistentQueue.add(SuccessOperation()))
        XCTAssert(persistentQueue.add(SuccessOperation()))
        
        // Waitw for expectations
        waitForExpectations(timeout: 2) { error in
            XCTAssert(persistentQueue.isEmpty)
            XCTAssert(error == nil)
        }
    }
    
    func test_retrayInfinity() {
        // Init
        test_retrayInfinityCount = 0
       
        // Operation
        struct RetrayInfinityOperation: PersistentSyncOperation {
            static var type: String = "RetrayInfinityOperation"
            
            func main() -> Bool {
                test_retrayInfinityCount += 1
                return test_retrayInfinityCount == 3
            }
        }
        
        struct SuccessOperation: PersistentSyncOperation {
            static var type: String = "SuccessOperation"
            
            func main() -> Bool {
                return true
            }
        }
        
        // Expectation
        let exp = expectation(description: "test_retrayInfinity")
        
        // Logic
        let persistentQueue = PersistentOperationQueue(path: path,
                                                       operationsTypes: [RetrayInfinityOperation.self, SuccessOperation.self],
                                                       tryCount: nil)
        persistentQueue.didReachedTryCountCallBack = { op in
            XCTFail()
        }
        
        persistentQueue.emptyCallBack = {
            exp.fulfill()
        }
        
        XCTAssert(persistentQueue.add(RetrayInfinityOperation()))
        XCTAssert(persistentQueue.add(SuccessOperation()))
        
        // Waitw for expectations
        waitForExpectations(timeout: 2) { error in
            XCTAssert(persistentQueue.isEmpty)
            XCTAssert(test_retrayInfinityCount == 3)
            XCTAssert(error == nil)
        }
    }
    
    func test_successAsync() {
        test_successAsyncCount = 0
        
        // Operation
        
        class SuccessOperation: PersistentAsyncOperation {

            // Operation Managment
            static var type: String = "SuccessOperation"
            
            // Operation Codable Properties
            enum CodingKeys: CodingKey {
                
            }
            
            func main(signal: @escaping OperationSignaller) {
                test_successAsyncCount += 1
                signal(test_successAsyncCount == 3)
            }
        }
        
        // Expectation
        let exp = expectation(description: "test_success")
        
        // Logic
        let persistentQueue = PersistentOperationQueue(path: path,
                                                       operationsTypes: [SuccessOperation.self],
                                                       tryCount: nil)
        persistentQueue.didReachedTryCountCallBack = { op in
            XCTFail()
        }
        
        persistentQueue.emptyCallBack = {
            exp.fulfill()
        }
        
        XCTAssert(persistentQueue.add(SuccessOperation()))
        
        // Waitw for expectations
        waitForExpectations(timeout: 2) { error in
            XCTAssert(test_successAsyncCount == 3)
            XCTAssert(persistentQueue.isEmpty)
            XCTAssert(error == nil)
        }
    }
}
