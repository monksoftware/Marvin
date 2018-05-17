//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case parseJSONError(Error, data: Data)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .parseJSONError(let e, _): return e.localizedDescription
        case .networkError(let e): return e.localizedDescription
        }
    }
}
