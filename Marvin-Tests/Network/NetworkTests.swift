//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import XCTest
import Marvin

func currentQueueName() -> String? {
    let name = __dispatch_queue_get_label(nil)
    return String(cString: name, encoding: .utf8)
}

class NetworkTests: XCTestCase {
    
    // _____________________________________________________________________________
    // MARK: - Queues
    
    func test_sync_fromMain() {
        Network.execute(mode: .sync, request: Requests.testGet(id: 1)) { _ in
            XCTAssert(Thread.isMainThread)
        }
    }
    
    func test_Sync_NotFromMain() {
        let exp = expectation(description: "test_sync_fromMain")
        let queue = DispatchQueue(label: "test_sync_fromMain", qos: .default);
        
        queue.async {
            Network.execute(mode: .sync,
                            request: Requests.testGet(id: 1))
            { _ in
                XCTAssertEqual(currentQueueName(), "test_sync_fromMain")
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 60);
    }
    
    func test_async() {
        let exp = expectation(description: "test_async")
        let queue = DispatchQueue(label: "test_async", qos: .default);
        
        Network.execute(mode: .async(responseQueue: queue),
                        request: Requests.testGet(id: 1))
        { _ in
            XCTAssertEqual(currentQueueName(), "test_async")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 60);
    }
    
    // _____________________________________________________________________________
    // MARK: - Methods
    
    func test_get_custom() {
        Network.execute(mode: .sync,
                        request: Requests.testGetCustom(id: 1))
        { result in
            switch result {
            case .ok(let response): XCTAssert(response.item.userId == 1)
            case .err(let error): XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_get() {
        let req = Requests.testGet(id: 12)
        
        Network.execute(mode: .sync,
                        request: req)
        { result in
            switch result {
            case .ok(let item):
                print(item)
            case .err(let e):
                switch e {
                case .networkError(_): break
                case .parseJSONError(_): break
                }
            }
        }
    }
    
    func test_delete() {
        let item = Item(userId: 1, title: "title", body: "body")
        let req = Requests.testDelete(item: item)
        
        Network.execute(mode: .sync,
                        request: req)
        { result in
            switch result {
            case .ok(let item):
                print(item)
            case .err(let e):
                switch e {
                case .networkError(_): break
                case .parseJSONError(_): break
                }
            }
        }
    }
    
    func test_operation() {
        let exp = expectation(description: "test_operation")
        
        let item = Item(userId: 1, title: "title", body: "body")
        let operation = DeleteOperation(item: item)
        operation.completionBlock = {
            exp.fulfill()
        }
        OperationQueue().addOperation(operation)
        
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail()
            }
        }
        
    }
}


class DeleteOperation: Operation, Codable {
    
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    override func main() {
        let req = Requests.testDelete(item: item)
        
        Network.execute(mode: .sync,
                        request: req)
        { result in
            switch result {
            case .ok(_):
                break
            case .err(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}












