//
//  HGPagingData.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/4/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

/// PagingData is used to iterate through requests which contain more than one page.
struct PagingData {
    
    let current: Int
    let previous: Int?
    let next: Int?
    let last: Int
    let per: Int
    
    init(current c: Int, last l: Int, per p: Int) {
        current = max(c, 1)
        last = l < current ? current : l
        next = current == last ? nil : current + 1
        previous = current == 1 ? nil : current - 1
        per = max(0,p)
    }
    
    // Creates a dummy file that won't be processed when creating requests (no paging information made when creating a URLRequest)
    init() {
        current = 0
        last = 0
        next = 0
        previous = 0
        per = 0
    }
    
    /// Determines the starting items index for the current page. (assuming you loaded all pages before the current page)
    var startingItemIndex: Int {
        let c = max(current - 1, 0)
        return c * per
    }
    
    /// Creates an stack array of PagingDatas, current page being at top of stack.
    var indexedPages: [PagingData] {
        
        var l = last
        var indexedPages: [PagingData] = []
        
        while l >= current {
            let indexedPage = PagingData(current: l, last: l, per: per)
            indexedPages.append(indexedPage)
            l -= 1
        }
        
        return indexedPages
    }
    
    /// Estimates the items left to download based on current page, last page, and items per page.
    var itemsLeftToDownload: Int {
        let itemsLeft = (last + 1 - current) * per
        return itemsLeft > 0 ? itemsLeft : 0
    }
    
    /// returns new pagingData for next page. If current page is last page, returns nil
    var increment: PagingData? {
        if current == last { return nil }
        return PagingData(current: max(current + 1, 1), last: last, per: per)
    }
    
    /// returns new pagingData for previous page.  If current page is first page, returns nil.
    var decrement: PagingData? {
        if current == 1 { return nil }
        return PagingData(current: max(current - 1, 1), last: last, per: per)
    }
    
    /// returns a PagingData with an update per value
    func update(per: Int) -> PagingData {
        return PagingData(current: self.current,
                          last: self.last,
                          per: per)
    }
    
    /// Attempts to create PagingData from a URLResponse.
    static func pagingData(urlResponse: URLResponse?) -> PagingData? {
        
        // attempts to determine PagingData from the header field Link (Github paging)
        if let httpResponse = urlResponse as? HTTPURLResponse {
            if let links = httpResponse.allHeaderFields["Link"] as? String {
                let pd = links.githubPagingData
                return pd
            }
        }
        
        return nil
    }
}
