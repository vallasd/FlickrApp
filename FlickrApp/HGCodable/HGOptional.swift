//
//  HGOptional.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

/// we are making an external var because creating a date formatter can be expensive if done a lot
fileprivate var dateFormatter1: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()

extension Optional {
    
    var array: HGARRAY {
        if let array = self as? HGARRAY { return array }
        HGReport.shared.optionalFailed(HGARRAY.self, object: self, returning: [])
        return []
    }
    
    var dict: HGDICT {
        if let dict = self as? HGDICT { return dict }
        HGReport.shared.optionalFailed(HGDICT.self, object: self, returning: [:])
        return [:]
    }
    
    var bool: Bool {
        if let b = self.checkBool { return b }
        HGReport.shared.optionalFailed(Bool.self, object: self, returning: false)
        return false
    }
    
    var optionalBool: Bool? {
        if let b = self.checkBool { return b }
        HGReport.shared.optionalFailed(Bool.self, object: self, returning: nil)
        return nil
    }
    
    var checkBool: Bool? {
        if let bool = self as? Bool {
            return bool
        }
        if let s = self as? String {
            if s == "T" || s == "t" || s == "True" || s == "true" { return true }
            if s == "F" || s == "f" || s == "False" || s == "false" { return false }
        }
        if let i = self as? Int {
            if i == 1 { return true }
            if i == 0 { return false }
        }
        return nil
    }
    
    var string: String {
        if let s = self.checkString { return s}
        HGReport.shared.optionalFailed(String.self, object: self, returning: "")
        return ""
    }
    
    var optionalString: String? {
        if let s = self.checkString { return s}
        HGReport.shared.optionalFailed(String.self, object: self, returning: nil)
        return nil
    }
    
    var checkString: String? {
        if let string = self as? String { return string }
        return nil
    }
    
    func string(withDefault d: String) -> String {
        if let string = self as? String {
            if string == "" {
                return d
            }
            return string
        }
        return d
    }
    
    var int: Int {
        if let i = self.checkInt { return i }
        HGReport.shared.optionalFailed(Int.self, object: self, returning: 0)
        return 0
    }
    
    var optionalInt: Int? {
        if let i = self.checkInt { return i }
        HGReport.shared.optionalFailed(Int.self, object: self, returning: nil)
        return nil
    }
    
    var checkInt: Int? {
        if let i = self as? Int { return i }
        if let s = self as? String { return Int(s) }
        if let f = self as? Float { return Int(f) }
        if let d = self as? Double { return Int(d) }
        return nil
    }
    
    var float: Float {
        if let f = self.checkFloat { return f }
        HGReport.shared.optionalFailed(Float.self, object: self, returning: 0)
        return 0
    }
    
    var optionalFloat: Float? {
        if let f = self.checkFloat { return f }
        HGReport.shared.optionalFailed(Float.self, object: self, returning: nil)
        return nil
    }
    
    var checkFloat: Float? {
        if let f = self as? Float { return f }
        if let d = self as? Double { return Float(d) }
        if let i = self as? Int { return Float(i) }
        if let s = self as? String { return Float(s) }
        return nil
    }
    
    var double: Double {
        if let d = self.checkDouble { return d }
        HGReport.shared.optionalFailed(Double.self, object: self, returning: 0)
        return 0
    }
    
    var optionalDouble: Double? {
        if let d = self.checkDouble { return d }
        HGReport.shared.optionalFailed(Double.self, object: self, returning: nil)
        return nil
    }
    
    var checkDouble: Double? {
        if let d = self as? Double { return d }
        if let f = self as? Float { return Double(f) }
        if let i = self as? Int { return Double(i) }
        if let s = self as? String { return Double(s) }
        return nil
    }
    
    var date: Date {
        if let d = self.checkDate { return d }
        HGReport.shared.optionalFailed(Date.self, object: self, returning: Date())
        return Date()
    }
    
    var optionalDate: Date? {
        if let d = self.checkDate { return d }
        HGReport.shared.optionalFailed(Date.self, object: self, returning: nil)
        return nil
    }
    
    var checkDate: Date? {
        if let date = self as? Date { return date }
        if let string = self as? String {
            if let date = dateFormatter1.date(from: string) { return date }
        }
        return nil
    }
}
