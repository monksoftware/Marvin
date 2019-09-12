//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//-

import Foundation

public func unreachable() -> Never {
    fatalError("unreachable")
}

public func unimplemented() -> Never {
    fatalError("Unimplemented")
}
