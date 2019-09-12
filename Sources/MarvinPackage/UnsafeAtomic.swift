//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

public class UnsafeAtomic<T> {
    private let queue = DispatchQueue(label: "", qos: .userInitiated)
    private var unsafeValue: T
    
    public init(_ value: T) {
        self.unsafeValue = value
    }
    
    public func execute(_ handler: (inout T) -> Void) {
        queue.sync {
            handler(&self.unsafeValue)
        }
    }
    
    public var value: T {
        get { return queue.sync { unsafeValue } }
        set { queue.sync {unsafeValue = newValue } }
    }
    
}
