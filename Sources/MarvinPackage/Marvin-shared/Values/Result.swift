//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public enum Result<T, E> {
    case ok(T)
    case err(E)
}

extension Result {
    
    public var isOk: Bool {
        switch self {
        case .ok(_): return true
        case .err(_): return false
        }
    }
    
    public var isErr: Bool {
        return !isOk
    }
    
    public var ok: Optional<T> {
        switch self {
        case .ok(let x): return .some(x)
        case .err(_): return .none
        }
    }
    
    public var err: Optional<E> {
        switch self {
        case .ok(_): return .none
        case .err(let x): return .some(x)
        }
    }
    
}

extension Result {
    
    public func map<U>(_ transform: (T) throws -> U) rethrows -> Result<U, E> {
        switch self {
        case .ok(let x): return .ok(try transform(x))
        case .err(let x): return .err(x)
        }
    }
    
    public func mapErr<U>(_ transform: (E) throws -> U) rethrows -> Result<T, U> {
        switch self {
        case .ok(let x): return .ok(x)
        case .err(let x): return .err(try transform(x))
        }
    }
    
    public func flatMap<U>(_ transform: (T) throws -> Result<U, E>) rethrows -> Result<U, E> {
        switch self {
        case .ok(let x): return try transform(x)
        case .err(let x): return .err(x)
        }
    }
    
    public func flatMapErr<U>(_ transform: (E) throws -> Result<T, U>) rethrows -> Result<T, U> {
        switch self {
        case .ok(let x): return .ok(x)
        case .err(let x): return try transform(x)
        }
    }
    
}

extension Result where T: Equatable, E: Equatable {
    public static func ==(lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case let (.ok(x), .ok(y)): return x == y
        case let (.err(x), .err(y)): return x == y
        default: return false
        }
    }
}
