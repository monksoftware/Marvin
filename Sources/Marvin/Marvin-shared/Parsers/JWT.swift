//
//  File.swift
//  
//
//  Created by Nelson Cardaci on 12/09/2019.
//

import Foundation

public struct JWT {
    
    public init() {}
    
    public func decode<T: Codable>(jwtToken jwt: String) -> T? {
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }
        
        func decodeJWTPart(_ value: String) -> T? {
            guard let data = base64UrlDecode(value) else {
                return nil
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch  {
                print("Error while decoding json:\(error.localizedDescription )")
                return nil
            }
            
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1])
    }
}
