//
//  Date.swift
//  FlickrApp
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

extension Date {
    
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    var simpleDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: self)
    }
    
}
