//
// This source file is part of the EIMe project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

func += <T>(left: inout Array<T>, right: T) {
    left.append(right)
}
