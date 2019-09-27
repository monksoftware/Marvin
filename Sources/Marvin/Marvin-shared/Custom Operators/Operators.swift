//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public func +(_ url: URL, string: String) -> URL {
    return url.appendingPathComponent(string)
}
