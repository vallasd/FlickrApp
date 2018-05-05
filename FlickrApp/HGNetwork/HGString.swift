//
//  HGString.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

extension String {
    
    /// Attempts to determine items per page from a URL string.
    var perPage: Int? {
        let components = self.components(separatedBy: ["?","&"])
        for component in components {
            if component.contains("per_page=") {
                let num = component.components(separatedBy: "per_page=").last
                if let n = num {
                    return Int(n)
                }
            }
        }
        return nil
    }
    
    /// Adds a parameter seperator to a URL string.
    var addParameterSeperator: String {
        if !self.contains("?") {
            return self + "?"
        } else {
            return self + "&"
        }
    }
    
    /// Strings extraneous text from a string if it exists. (removes ], >, }, or = if at end of string)
    var stripBracket: String {
        let lastChar = self.last
        if lastChar == "]" || lastChar == ">" || lastChar == "}" || lastChar == "=" {
            let string = String(self.dropLast())
            return string
        }
        return self
    }
    
    /// Returns a specific parameter in a URL string.  If parameter does not exist, returns nil.
    func getURLParameter(parameter: String) -> String? {
        
        let equalsStripped = parameter.stripBracket
        let urlcomponents = self.components(separatedBy: ["<", ">", "?", "&", "{", "}"])
        for string in urlcomponents {
            if string.hasPrefix(equalsStripped) {
                if string.contains("=") {
                    return string.components(separatedBy: "=").last
                }
                return string
            }
        }
        
        return nil
    }
    
    /// Returns PagingData for Github header (link)
    var githubPagingData: PagingData? {
        
        let links = self.components(separatedBy: ",")
        
        var current = -1
        var next = -1
        var previous = -1
        var last = -1
        
        for link in links {
            
            let parts = link.components(separatedBy: ";")
            guard let rel = parts.last else { break }
            guard let url = parts.first else { break }
            
            if rel.contains("next") {
                let value = url.getURLParameter(parameter: "page")
                let intValue = value != nil ? Int(value!) : -1
                next = intValue ?? -1
            }
            
            if rel.contains("last") {
                let value = url.getURLParameter(parameter: "page")
                let intValue = value != nil ? Int(value!) : -1
                last = intValue ?? -1
            }
            
            if rel.contains("previous") {
                let value = url.getURLParameter(parameter: "page")
                let intValue = value != nil ? Int(value!) : -1
                previous = intValue ?? -1
            }
        }
        
        if previous != -1 {
            current = previous + 1
        }
        
        if next != -1 {
            current = next - 1
        }
        
        if current != -1 && last != -1 {
            return PagingData(current: current, last: last, per: 0)
        }
        
        return nil
    }
}
