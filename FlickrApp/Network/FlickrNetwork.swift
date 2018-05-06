//
//  FlickrNetwork.swift
//  FlickrApp
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

class FlickrNetwork {
    
    static let shared = FlickrNetwork()
    let apiKey = "6699dd424eb9671f768ac84dfd3d0494"
    let baseURL = "https://api.flickr.com/services/rest/"
    
    /// Gets the Interestingness photos and PageData for a specific day.
    func getInterestingnessPhotos<A: HGCodable>(date: Date, pagingData: PagingData?, completion: @escaping (ResultWithPagingData<[A]>) -> ()) {
        
        var parameters: RequestDict = [
            "method" : "flickr.interestingness.getList",
            "api_key" : apiKey,
            "format" : "json",
            "extras": "owner_name,date_taken,description",
            "nojsoncallback" : "1",
            "date" : date.simpleDate,
        ]
        
        if pagingData == nil { parameters["per_page"] = "100" }
        
        let requestData = RequestData(baseURL: baseURL,
                                      httpMethod: nil,
                                      timeout: 5.0,
                                      pagingData: pagingData,
                                      headers: [:],
                                      parameters: parameters)
        
        HGNetwork.shared.performRequest(requestData: requestData) { (results) in
            completion(results)
        }
    }
    
    
}
