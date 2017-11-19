//
//  Date.swift
//  Marvin
//
//  Created by Alessio Arsuffi on 16/11/2017.
//  Copyright © 2017 Monksoftware. All rights reserved.
//

import Foundation

// MARK: - Date
public extension Date {
    
    // MARK: - Milliseconds
    
    /// Init new date with given milliseconds
    ///
    /// - Parameter milliseconds: millis to calculate date from 1970
    public init(milliseconds: Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    /// This property returns millisecondsSince1970 from this date
    public var millisecondsSince1970: Double {
        return self.timeIntervalSince1970 * 1000.0
    }
    
    // MARK: - Date format
    
    /// Return a string from format specified
    ///
    /// - Parameter format: Date format (ex: "yyyy mm dd")
    ///    default: yyyy mm dd
    /// - Returns: a string from date
    
    ///   - format: Date format (ex: "yyyy mm dd")
    ///    default: yyyy mm dd
    ///   - locale: locale identifier, default "it_IT"
    /// - Returns: a string from date
    public func string(dateFormat format: String? = "yyyy MM dd", locale: String = "it_IT") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
