//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

// MARK: - Persistent Operation

public protocol PersistentOperation: Codable {
    static var type: String { get }
    var tryCount: Int? { get }
    func start() -> Bool
}

extension PersistentOperation {
    static func make(json: String) -> Self? {
        let data = json.data(using: .utf8)!
        return try? JSONDecoder().decode(self, from: data)
    }
    
    public var tryCount: Int? { return nil }
    
    func save(at url: URL) throws {
        let jsonData = try JSONEncoder().encode(self)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        try jsonString.write(to: url, atomically: true, encoding: .utf8)
    }
}

// MARK: - Persistent Sync Operation

public protocol PersistentSyncOperation: PersistentOperation {
    func main() -> Bool
}

public extension PersistentSyncOperation {
    func start() -> Bool {
        return main()
    }
}

// MARK: - Persistent Async Operation

public typealias OperationSignaller = ((Bool) -> Void)

public protocol PersistentAsyncOperation: class, PersistentOperation {
    func main(signal: @escaping OperationSignaller)
}

public extension PersistentAsyncOperation {
    func start() -> Bool {
        let blockResult = BlockResult()
        DispatchQueue.global().async {
            self.main(signal: blockResult.signal)
        }
        return blockResult.wait()
    }
}

private class BlockResult {
    private let semaphore = DispatchSemaphore(value: 0)
    public var result = false

    func wait() -> Bool {
        semaphore.wait()
        return result
    }

    func signal(with result: Bool) {
        self.result = result
        semaphore.signal()
    }
}
