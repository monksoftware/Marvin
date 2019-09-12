//
// This source file is part of the Marvin open source project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation

extension Data {
    
    public var json: String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)
        } catch {
            return String(data: self, encoding: .utf8)
        }
    }
    
}

extension Date {
    
    public var unixTime: Int {
        return Int(self.timeIntervalSinceReferenceDate)
    }
    
}

extension JSONSerialization {
    public static func string<T>(from dictionary: [T : Any]) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
