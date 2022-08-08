//
//  Dictionary+PrettyPrint.swift
//  Core
//
//  Created by Serhii Navka on 11.04.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

extension Dictionary where Key: CustomStringConvertible, Value: Any {
 
    public var prettyString: String {
        do {
            let prettyData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .withoutEscapingSlashes])
            return String(data: prettyData, encoding: .utf8) ?? "error encoding data"
        } catch {
            return "Invalid JSON in \(#function)"
                + "\n"
                + "RAW:"
                + "\n"
                + String(describing: self)
        }
    }
    
}
