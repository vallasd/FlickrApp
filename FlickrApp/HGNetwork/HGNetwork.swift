//
//  HGNetwork.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/4/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

/// This class performs URL Requests.  Will return Results on main thread if processNetworkCompletionHandlersOnMainThread is set to true.  HGNetwork folder is dependent on HGCodable, HGReport and HGFunctional folders.
class HGNetwork {
    
    static let shared = HGNetwork()
    
    let processNetworkCompletionHandlersOnMainThread = true
    
    // MARK: - Public Functions
    
    /// Performs multiple requests based off of PagingData in RequestData.  Will attempt to determine PagingData and return this info to the user with array of HGCodable Objects or Error.  Completion handler will be called for each request called.  If current page is 1, last page is 5 in page data, 1,2,3,4,5 completion times will be called.  If pagingData is nil in RequestData, request will be created without the paging data and run once.
    func performRequest<A: HGCodable>(requestData: RequestData, completion: @escaping (ResultWithPagingData<[A]>) -> ()) {
        
        // If pagingData in requestData is nil, we will make a dummy paging.  Dummy page will not be processed in request.
        var pagingData = requestData.pagingData != nil ? requestData.pagingData : PagingData()
        
        while pagingData != nil {
            
            let newRequestData = requestData.create(withPagingData: pagingData!)
            let result: Result<URLRequest> = newRequestData.urlRequest
            
            switch result {
            case let .value(request):
                performRequest(request: request, completion: { [weak self] (result) in
                    self?.process(result: result, completion: completion)
                })
            case let .error(error):
                let errorResult: ResultWithPagingData<[A]> = ResultWithPagingData(error)
                completion(errorResult)
            }
            
            pagingData = pagingData?.increment
        }
    }
    
    /// Performs multiple requests based off of PagingData in RequestData.  Will return result as HGCodable Object or Error.  Completion handler will be called for each request called.  If current page is 1, last page is 5 in page data, 1,2,3,4,5 completion times will be called.  If pagingData is nil in RequestData, request will be created without the paging data and run once.
    func performRequest<A: HGCodable>(requestData: RequestData, completion: @escaping (Result<A>) -> ()) {
        
        // If pagingData in requestData is nil, we will make a dummy paging.  Dummy page will not be processed in request.
        var pagingData = requestData.pagingData != nil ? requestData.pagingData : PagingData()
        
        while pagingData != nil {
            
            let newRequestData = requestData.create(withPagingData: pagingData!)
            let result: Result<URLRequest> = newRequestData.urlRequest
            
            switch result {
            case let .value(request):
                performRequest(request: request, completion: { [weak self] (result) in
                    self?.process(result: result, completion: completion)
                })
            case let .error(error):
                let errorResult: Result<A> = resultFromOptional(optional: nil, error: error)
                completion(errorResult)
            }
            
            pagingData = pagingData?.increment
        }
    }
    
    /// Performs multiple requests based off of PagingData in RequestData.  Will return result as array of HGCodable Objects or Error.  Completion handler will be called for each request called.  If current page is 1, last page is 5 in page data, 1,2,3,4,5 completion times will be called.  If pagingData is nil in RequestData, request will be created without the paging data and run once.
    func performRequest<A: HGCodable>(requestData: RequestData, completion: @escaping (Result<[A]>) -> ()) {
        
        // If pagingData in requestData is nil, we will make a dummy paging.  Dummy page will not be processed in request.
        var pagingData = requestData.pagingData != nil ? requestData.pagingData : PagingData()
        
        while pagingData != nil {
            
            let newRequestData = requestData.create(withPagingData: pagingData!)
            let result: Result<URLRequest> = newRequestData.urlRequest
            
            switch result {
            case let .value(request):
                performRequest(request: request, completion: { [weak self] (result) in
                    self?.process(result: result, completion: completion)
                })
            case let .error(error):
                let errorResult: Result<[A]> = resultFromOptional(optional: nil, error: error)
                completion(errorResult)
            }
            
            pagingData = pagingData?.increment
        }
    }
    
    /// Performs a request for URLRequest.  Will return a HGCodable Object or Error.
    func performRequest<A: HGCodable>(request: URLRequest, completion: @escaping (Result<A>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let s = self else { return }
            let result: Result<A> = s.parseResult(data: data, urlResponse: urlResponse, error: error)
            s.process(result: result, completion: completion)
        }
        task.resume()
    }
    
    /// Performs a request for URLRequest.  Will return an array of HGCodable Objects or Error.
    func performRequest<A: HGCodable>(request: URLRequest, completion: @escaping (Result<[A]>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let s = self else { return }
            let result: Result<[A]> = s.parseResult(data: data, urlResponse: urlResponse, error: error)
            s.process(result: result, completion: completion)
        }
        task.resume()
    }
    
    /// Performs a request for URLRequest.  Will an array of HGCodable Objects with optional PagingData (if it can be determined) or Error.
    func performRequest<A: HGCodable>(request: URLRequest, completion: @escaping (ResultWithPagingData<[A]>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let s = self else { return }
            var result: ResultWithPagingData<[A]> = s.parseResult(data: data, urlResponse: urlResponse, error: error)
            result = s.resultWithPagingData(result: result, request: request)
            s.process(result: result, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - Private Functions
    
    /// Attempts to decode JSON into a HGCodable Object.  Returns object or Error.
    fileprivate func parseResult<A: HGCodable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<A> {
        let responseResult: Result<Data> = result(data: data, urlResponse: urlResponse, error: error)
        return responseResult >>> decodeJSON >>> decodeObject
    }
    
    /// Attempts to decode JSON into an array of HGCodable Objects.  Returns array of objects or Error.
    fileprivate func parseResult<A: HGCodable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<[A]> {
        let responseResult: Result<Data> = result(data: data, urlResponse: urlResponse, error: error)
        return responseResult >>> decodeJSON >>> decodeObject
    }
    
    /// Attempts to decode JSON into an array of HGCodable Objects.  Returns array objects with optional PagingData or Error.
    fileprivate func parseResult<A: HGCodable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> (ResultWithPagingData<[A]>) {
        let result: Result<[A]> = parseResult(data: data, urlResponse: urlResponse, error: error)
        let pd = PagingData.pagingData(urlResponse: urlResponse) ?? PagingData.pagingData(data: data)
        let resultWithPagingData = ResultWithPagingData(result, pagingData: pd)
        return resultWithPagingData
    }
    
    /// Processes completion handler.  (On main thread if processNetworkCompletionHandlersOnMainThread is set to true)
    fileprivate func process<A: HGCodable>(result: ResultWithPagingData<[A]>, completion: @escaping (ResultWithPagingData<[A]>) -> ()) {
        if processNetworkCompletionHandlersOnMainThread {
            DispatchQueue.main.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }
    
    /// Processes completion handler.  (On main thread if processNetworkCompletionHandlersOnMainThread is set to true)
    fileprivate func process<A: HGCodable>(result: Result<A>, completion: @escaping (Result<A>) -> ()) {
        if processNetworkCompletionHandlersOnMainThread {
            DispatchQueue.main.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }
    
    /// Processes completion handler.  (On main thread if processNetworkCompletionHandlersOnMainThread is set to true)
    fileprivate func process<A: HGCodable>(result: Result<[A]>, completion: @escaping (Result<[A]>) -> ()) {
        if processNetworkCompletionHandlersOnMainThread {
            DispatchQueue.main.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }
    
    /// This function tries to update the per page count for a result if we weren't able to find it before
    fileprivate func resultWithPagingData<A: HGCodable>(result: ResultWithPagingData<[A]>, request: URLRequest) -> ResultWithPagingData<[A]> {
        
        switch result {
        case let .value(x):
            if let pagingData = x.pagingData {
                if pagingData.per == 0 {
                    
                    // check request url to try to attain per page count
                    if let perPage = request.url?.absoluteString.perPage {
                        let newPD = pagingData.update(per: perPage)
                        return ResultWithPagingData(result, pagingData: newPD)
                    }
                    
                    // use count of objects to attain per page
                    if x.value.count != 0 {
                        let newPD = pagingData.update(per: x.value.count)
                        return ResultWithPagingData(result, pagingData: newPD)
                    }
                    
                    // we still have a 0 count for per page, so we dont return any paging data
                    return ResultWithPagingData(result, pagingData: nil)
                }
            }
            return result
        case .error:
            return result
        }
    }
    
    /// Processes data, urlResponse, and error sent back from a request and either returns the data or an Error in the Result.
    fileprivate func result(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<Data> {
        
        // return error if there is one
        if let e = error {
            return .error(e)
        }
        
        // get localized error, if response status code is not a successful one
        if let httpResponse = urlResponse as? HTTPURLResponse {
            let code = httpResponse.statusCode
            let successRange = 200..<300
            if !successRange.contains(code) {
                let message = HTTPURLResponse.localizedString(forStatusCode: code)
                let error = NSError.error(message: message, code: code)
                return .error(error)
            }
        }
        
        // return data if some is received and there were no errors or bad responses
        if let d = data {
            return .value(d)
        }
        
        // return generic error, if data was nil
        return .error(NSError.dataError)
    }

    
    
}
