//
//  HGError.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

extension Error {
    
    /// Prints the Error to log in specific format
    func display() {
        print("Error: code: \((self as NSError).code) info: \(self.localizedDescription)")
    }
    
    static var decodeData: Error {
        let msg = "Unable to decode JSON from data"
        return NSError(domain: "", code: 501, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func decodeObject<T>(_ type: T) -> Error {
        let msg = "Unable to decode |\(type)| from JSON"
        return NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func decodeObjectArray<T>(_ type: T) -> Error {
        let msg = "Unable to decode |[\(type)]| from JSON"
        return NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func createURL(_ urlString: String) -> Error {
        let msg = "Unable to create url with string \(urlString)"
        return NSError(domain: "", code: 503, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static var dataError: Error {
        let msg = "Did not receive data from request"
        return NSError(domain: "", code: 504, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static var pagingDataError: Error {
        let msg = "Unable to retrieve paging information for request"
        return NSError(domain: "", code: 505, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func error(message msg: String, code: Int) -> Error {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: msg])
    }
}
