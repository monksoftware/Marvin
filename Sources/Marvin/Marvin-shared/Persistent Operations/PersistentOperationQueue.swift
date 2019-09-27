//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public class PersistentOperationQueue {
    
    // MARK: Init
    
    public init(path: URL,
                operationsTypes: [PersistentOperation.Type],
                tryCount: Int?) {
        tryCount.map { precondition($0 > 0) }
        self.path = path
        self.operationsTypes = operationsTypes
        self.tryCount = tryCount
        self.list = loadPersistentList()
        
        let fm = FileManager.default
        try! fm.createDirectory(at: path, withIntermediateDirectories: true)
    }
    
    // MARK: Inner Types
    
    private class ListEntry: Equatable, Codable {
        let id: String
        let type: String
        var tryCount: Int?
        
        static func ==(lhs: PersistentOperationQueue.ListEntry,
                       rhs: PersistentOperationQueue.ListEntry) -> Bool {
            return lhs.id == rhs.id
        }
        
        init(id: String, type: String, tryCount: Int?) {
            self.id = id
            self.type = type
            self.tryCount = tryCount
        }
    }
    
    // MARK: Queues
    
    private let operationsQueue = DispatchQueue(label: "operationsQueue",
                                                qos: .userInteractive)
    
    private let threadSafeQueue = DispatchQueue(label: "threadSafeQueue",
                                                qos: .userInteractive)
    
    // MARK: Properties
    
    private var path: URL
    private var operationsTypes: [PersistentOperation.Type]
    private var list = [ListEntry]()
    private var active = false
    private let tryCount: Int?
    
    // MARK: Delegate
    
    public var didReachedTryCountCallBack: ((PersistentOperation) -> Void)?
    public var emptyCallBack: (() -> Void)?
    
    // MARK: Paths
    
    private var listPath: URL {
        return path.appendingPathComponent("list.json")
    }
    
    private func pathForOperationID(_ id: String) -> URL {
        return path.appendingPathComponent(id).appendingPathExtension(".json")
    }
    
    // MARK: Is empty
    
    public var isEmpty: Bool {
        return threadSafeQueue.sync {
            return list.isEmpty
        }
    }
    
    // MARK: List
    
    private func removeFromPersistentList(entry: ListEntry) -> Bool {
        do {
            var newList = list
            
            guard let index = newList.firstIndex(of: entry) else {
                return true
            }
            
            newList.remove(at: index)
            
            let jsonData = try JSONEncoder().encode(newList)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try jsonString.write(to: listPath, atomically: true, encoding: .utf8)
            list = newList
            return true
        } catch {
            return false
        }
    }
    
    private func appendToPersistentList(entry: ListEntry) -> Bool {
        do {
            var newList = list
            newList.append(entry)
            let jsonData = try JSONEncoder().encode(newList)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try jsonString.write(to: listPath, atomically: true, encoding: .utf8)
            list = newList
            return true
        } catch {
            return false
        }
    }
    
    private func loadPersistentList() -> [ListEntry] {
        do {
            let jsonString = try String(contentsOf: listPath)
            let jsonData = jsonString.data(using: .utf8)!
            return try JSONDecoder().decode([ListEntry].self, from: jsonData)
        } catch {
            return []
        }
    }
    
    private func updateList() {
        do {
            let newList = list
            let jsonData = try JSONEncoder().encode(newList)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try jsonString.write(to: listPath, atomically: true, encoding: .utf8)
        } catch {
            print("Fail update list")
        }
    }
    
    // MARK: Operations
    
    private func deleteOperationWithotRemoveFromList(at url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
    
    private func deleteOperation(_ element: ListEntry) {
        let url = pathForOperationID(element.id)
        if !deleteOperationWithotRemoveFromList(at: url) {
            print("Removed operation withoud deleted file")
        }
        if !removeFromPersistentList(entry: element) {
            print("Removed operation withoud updated list")
        }
    }
    
    private func saveOperation(_ op: PersistentOperation) -> Bool {
        do {
            let id = UUID().uuidString
            let url = pathForOperationID(id)
            
            try op.save(at: url)
            
            let entry = ListEntry(id: id, type: type(of: op).type, tryCount: op.tryCount ?? tryCount)
            
            guard appendToPersistentList(entry: entry)  else {
                if !deleteOperationWithotRemoveFromList(at: url) {
                    print("Fail deleted operation")
                }
                return false
            }
            return true
        } catch {
            return false
        }
    }
    
    private func loadOperation(_ element: ListEntry) -> PersistentOperation? {
        do {
            let url = pathForOperationID(element.id)
            let jsonString = try String(contentsOf: url)
            
            let _type = operationsTypes.first {
                $0.type == element.type
            }
            
            guard let type = _type else {
                print("Operation type not found")
                return nil
            }
            
            return type.make(json: jsonString)
        } catch {
            return nil
        }
    }
    
    // MARK: Schedule
    
    public func start() {
        threadSafeQueue.sync {
            schedule()
        }
    }
    
    private func schedule() {
        guard !active else {
            return
        }
        
        guard list.count > 0 else {
            emptyCallBack?()
            return
        }
        
        
        let entry = list.first!
        entry.tryCount? -= 1
        updateList()
        
        guard let operation = loadOperation(entry) else {
            print("Error load operation")
            deleteOperation(entry)
            schedule()
            return
        }
        
        if let x = entry.tryCount, x < 0 {
            print("Deleted cause tryCount == 0")
            didReachedTryCountCallBack?(operation)
            deleteOperation(entry)
            schedule()
            return
        }
        
        active = true
        operationsQueue.async {
            let result = operation.start()
            self.threadSafeQueue.async {
                self.active = false
                if result == true {
                    self.deleteOperation(entry)
                }
                self.schedule()
            }
        }
    }
    
    // MARK: Add
    @discardableResult
    public func add(_ op: PersistentOperation) -> Bool {
        return threadSafeQueue.sync {
            if saveOperation(op) {
                schedule()
                return true
            } else {
                return false
            }
        }
    }
}
