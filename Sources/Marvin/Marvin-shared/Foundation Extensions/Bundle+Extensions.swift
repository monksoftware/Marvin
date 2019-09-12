//
// This source file is part of the EIMe project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

extension Bundle {
    var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var build: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
