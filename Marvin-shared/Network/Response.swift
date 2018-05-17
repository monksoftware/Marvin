//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public protocol Response {
    static func make(jsonData: Data) -> ErrorResult<Self>
    static func decode<T>(c: (JSONDecoder) throws -> T) -> ErrorResult<T>
}

public extension Response {
    static func decode<T>(c: (JSONDecoder) throws -> T) -> Result<T, Error>{
        do {
            return .ok(try c(JSONDecoder()))
        } catch {
            return .err(error)
        }
    }
}
