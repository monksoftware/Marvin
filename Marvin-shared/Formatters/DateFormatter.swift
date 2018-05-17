//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

extension Date {
    
    /// Format date to specified format,
    ///
    /// if not specified, default format is "HH:mm"
    ///
    /// - Returns: date converted into string
    public func string(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    private static let iso8601Pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    public var iso8601: String {
        return string(format: Date.iso8601Pattern)
    }
    
    public static func makeFromIOS8601(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        formatter.dateFormat = Date.iso8601Pattern
        let date = formatter.date(from: string)
        return date
    }
        
}
