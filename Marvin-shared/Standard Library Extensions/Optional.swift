//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

extension Optional {
    
    public func result<T>(error: T) -> Result<Wrapped, T>{
        switch self {
        case .some(let x): return .ok(x)
        case .none: return .err(error)
        }
    }
}
