//
//  HGRequestData.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/4/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

typealias RequestDict = Dictionary<String, String>

enum HttpMethod {
    case get
    case post
    case put
    case delete
    
    var string: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

/// Data set used to create URLRequests for HGNetwork.
struct RequestData {
    
    let baseURL: String
    let httpMethod: HttpMethod?
    let timeout: Double
    let pagingData: PagingData?
    let headers: RequestDict
    let parameters: RequestDict
    
    init(baseURL bu: String, httpMethod http: HttpMethod?, timeout t: Double, pagingData pd: PagingData?, headers h: RequestDict, parameters p: RequestDict) {
        baseURL = bu
        httpMethod = http
        timeout = t
        pagingData = pd
        headers = h
        parameters = p
    }
    
    init(baseURL bu: String) {
        baseURL = bu
        httpMethod = .get
        timeout = 5.0
        pagingData = nil
        headers = [:]
        parameters = [:]
    }
    
    init(baseURL bu: String, method m: HttpMethod, headers h: RequestDict, parameters p: RequestDict) {
        baseURL = bu
        httpMethod = m
        timeout = 5.0
        pagingData = nil
        headers = h
        parameters = p
    }
    
    init(baseURL bu: String, perPage: Int) {
        baseURL = bu
        httpMethod = .get
        timeout = 5.0
        pagingData = PagingData(current: 1, last: 1, per: perPage)
        headers = [:]
        parameters = [:]
    }
    
    init(baseURL bu: String, pagingData pd: PagingData) {
        baseURL = bu
        httpMethod = .get
        timeout = 5.0
        pagingData = pd
        headers = [:]
        parameters = [:]
    }
    
    /// Adds a PageingData to the RequestData
    func create(withPagingData: PagingData?) -> RequestData {
        
        return RequestData(baseURL: baseURL,
                           httpMethod: httpMethod,
                           timeout: timeout,
                           pagingData: withPagingData,
                           headers: headers,
                           parameters: parameters)
    }
    
    /// Increments the PagingData by one in a RequestData (if PagingData exists)
    var incrementPage: RequestData {
        let newPD = pagingData?.increment
        let newRequestData = RequestData(baseURL: baseURL,
                                         httpMethod: httpMethod,
                                         timeout: timeout,
                                         pagingData: newPD,
                                         headers: headers,
                                         parameters: parameters)
        return newRequestData
    }
    
    /// Creates a URLRequest for the RequestData.  If a request can not be created, returns an Error.
    var urlRequest: Result<URLRequest> {
        
        var urlString = baseURL
        
        for key in parameters.keys {
            urlString = urlString.addParameterSeperator
            let value = parameters[key].string
            urlString = urlString + "\(key)=\(value)"
        }
        
        // add per_page if needed
        if let p = pagingData?.per, p > 0 {
            urlString = urlString.addParameterSeperator
            urlString = urlString + "per_page=\(p)"
        }
        
        // add page if needed
        if let c = pagingData?.current, c > 0 {
            urlString = urlString.addParameterSeperator
            urlString = urlString + "page=\(c)"
        }
        
        // return error if url can not be created
        guard let url = URL(string: urlString) else {
            let error = NSError.createURL(urlString)
            return .error(error)
        }
        
        // create urlreqeust
        let request = NSMutableURLRequest(url: url)
        
        // add headers if necessary
        for key in headers.keys {
            request.addValue(headers[key].string, forHTTPHeaderField: key)
        }
        
        // define httpMethod
        if let method = httpMethod {
            request.httpMethod = method.string
        }
        
        // define timeout interval
        request.timeoutInterval = Double(timeout)
        
        // copy it to a URL Request
        let r = request.copy() as! URLRequest
        
        return .value(r)
    }
}
