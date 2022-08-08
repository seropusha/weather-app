//
//  Data+PrettyPrinted.swift
//  Core
//
//  Created by Serhii Navka on 11.04.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

extension Data {
    
    public var prettyString: String {
        do {
            let obj = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            guard JSONSerialization.isValidJSONObject(obj) else {
                return String(data: self, encoding: .utf8) ?? "NOT VALID DATA"
            }
            
            let prettyData = try JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .withoutEscapingSlashes])
            return String(data: prettyData, encoding: .utf8) ?? "error encoding data"
        } catch {
            return self.isEmpty ? "" : "NOT VALID JSON"
                + "\n"
                + (String(data: self, encoding: .utf8) ?? "error encoding data")
        }
    }
}
