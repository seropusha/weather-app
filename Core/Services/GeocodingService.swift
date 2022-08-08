//
//  GeocodingService.swift
//  Core
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public final class GeocidingService {
    
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func search(_ query: String) async -> Result<[CityResponse]> {
        let request = SearchCityByQueryRequest(city: query, limit: 30)
        let parser = DecodableParser<[CityResponse]>()
        
        return await client.execute(request, parser: parser)
    }
}
