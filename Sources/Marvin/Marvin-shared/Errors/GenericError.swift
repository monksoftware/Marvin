//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public struct GenericError: Error, LocalizedError {
    public let description: String
    public var errorDescription: String? { return description}
    
    public init(description: String) {
        self.description = description
    }
}
