//
//  IconId.swift
//  Core
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public typealias IconId = String

extension IconId {
    public func buildImageURL() -> URL? {
        guard !isEmpty else { return nil }
        
        return URL(string: "https://openweathermap.org/img/wn/\(self)@2x.png")
    }
}
