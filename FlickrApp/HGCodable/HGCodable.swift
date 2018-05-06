//
//  HGCodable.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

/// Protocol for Coding and Decoding objects.  Different than swifts Codable and Encodable protocol in that an HGCodable object is expected to return itself, not an optional or thrown error.  User is expected to use default values and handle error reporting within the encode and decode functions. (Use HGOptional, to unwrap Primitives with proper error reporting) This Folder is dependent on HGReport.
protocol HGCodable {
    var encode: Any { get }
    static func decode(object: Any) -> Self
    static func decode(object: Any) -> [Self]
}

extension HGCodable {
    
    /// Attempts to decode an object into an array of objects of Type HGCodable.  Returns empty array an reports Error if unable to make an array.
    static func decode(object: Any) -> [Self] {
        
        guard let a = object as? HGARRAY else {
            HGReport.shared.decodeFailed(HGARRAY.self, object: object)
            return []
        }
        var array: [Self] = []
        for object in a {
            let decodedObject: Self = decode(object: object)
            array.append(decodedObject)
        }
        return array
    }
    
    // MARK: - User Defaults
    
    /// Encodes and saves an object to standard user defaults given a key
    func saveDefaults(_ key: String) {
        let encoded = self.encode
        UserDefaults.standard.setValue(encoded, forKey: key)
    }
    
    /// Removes object with key from standard user defaults
    static func removeDefaults(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// Switches key names for object in standard user defaults
    static func switchDefaults(oldkey: String, newkey: String) {
        let project = UserDefaults.standard.value(forKey: oldkey)
        UserDefaults.standard.setValue(project, forKey: newkey)
        UserDefaults.standard.removeObject(forKey: oldkey)
    }
    
    /// Opens and decodes object from standard user defaults given a key
    static func openDefaults(_ key: String) -> Self? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: key) {
            let decoded: Self = Self.decode(object: object)
            return decoded
        }
        HGReport.shared.defaultsFailed(Self.self, key: key)
        return nil
    }
}

extension HGCodable where Self: Hashable {
    
    /// Decodes an array of objects into an set of [HGCodable]
    static func decode(object: Any) -> Set<Self> {
        
        guard let a = object as? HGARRAY else {
            HGReport.shared.decodeFailed(HGARRAY.self, object: object)
            return []
        }
        
        var set: Set<Self> = []
        for object in a {
            let decodedObject: Self = decode(object: object)
            let inserted = set.insert(decodedObject).inserted
            if !inserted {
                HGReport.shared.setDecodeFailed(Self.self, object: decodedObject)
            }
        }
        return set
    }
}

extension Set where Iterator.Element: HGCodable {
    
    /// Encodes a Set of HGCodable
    var encode: [Any] {
        return self.map { $0.encode }
    }
}

extension Array where Iterator.Element: HGCodable {
    
    /// Encodes an Array of HGCodable
    var encode: [Any] {
        return self.map { $0.encode }
    }
    
}
