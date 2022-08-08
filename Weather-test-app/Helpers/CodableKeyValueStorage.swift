//
//  CodableKeyValueStorage.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Combine

public protocol CodableKeyValueStorage {
    
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var notificationCenter: NotificationCenter { get }
    func setObject<T>(_ value: T?, forKey key: String) where T: Codable
    func object<T>(forKey key: String) -> T? where T: Codable
    func publisher<T>(key: String, defaultValue: T) -> AnyPublisher<T, Never> where T: Equatable, T: Codable
    
}

extension UserDefaults: CodableKeyValueStorage {
    
    public var encoder: JSONEncoder {
        .default
    }
    
    public var decoder: JSONDecoder {
        .default
    }
    
    public var notificationCenter: NotificationCenter {
        .default
    }
    
    public func setObject<T>(_ value: T?, forKey key: String) where T: Codable {
        switch value {
        case .none:
            self.set(nil, forKey: key)
            
        case .some(let wrapped):
            switch wrapped {
            case is Bool: // have fixed problem when Bool can't be encoded to `Data` on some devices
                self.set(value, forKey: key)
                
            default:
                let data = try? encoder.encode(value)
                self.set(data, forKey: key)
            }
        }
    }
    
    public func object<T>(forKey key: String) -> T? where T: Codable {
        let value = self.object(forKey: key)
        switch value {
        case is Bool:
            return value as? T
            
        default:
            guard let data = self.object(forKey: key) as? Data else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
    }
    
    public func publisher<T>(key: String, defaultValue: T) -> AnyPublisher<T, Never> where T: Equatable, T: Codable {
        notificationCenter
            .publisher(for: UserDefaults.didChangeNotification)
            .compactMap { [weak self] _ in self?.object(forKey: key) ?? defaultValue }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
