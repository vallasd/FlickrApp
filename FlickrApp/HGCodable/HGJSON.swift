//
//  HGJSON.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

typealias JSON = Any
typealias HGDICT = Dictionary<String, Any>
typealias HGARRAY = [HGDICT]

class HG {
    
    /// Returns an HGDICT.  If hgdict can not be unwrapped as HGDICT, produces an error message and returns an empty HGDICT.
    static func decode<T>(hgdict: Any, decoder: T) -> HGDICT {
        if let dict = hgdict as? HGDICT { return dict }
        HGReport.shared.decodeFailed(decoder, object: hgdict)
        return HGDICT()
    }
    
    /// Returns an HGARRAY.  If hgarray can not be unwrapped as HGARRAY, produces an error message and returns an empty HGARRAY.
    static func decode<T>(hgarray: Any, decoder: T) -> HGARRAY {
        if let array = hgarray as? HGARRAY { return array }
        HGReport.shared.decodeFailed(decoder, object: hgarray)
        return HGARRAY()
    }
    
}
