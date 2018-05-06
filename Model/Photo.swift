//
//  Photo.swift
//  FlickrApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

struct Photo: HGCodable {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Bool
    let isfriend: Bool
    let isfamily: Bool
    
    // extras
    let ownerName: String
    let dateTaken: Date?
    let description: String
    
    var thumbnailURL: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg")
    }
    
    var imageURL: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_z.jpg")
    }
    
    
    // MARK: - HGCodable
    
    var encode: Any {
        var dict = HGDICT()
        dict["id"] = id
        dict["owner"] = owner
        dict["secret"] = secret
        dict["server"] = server
        dict["farm"] = farm
        dict["title"] = title
        dict["ispublic"] = ispublic
        dict["isfriend"] = isfriend
        dict["isfamily"] = isfamily
        dict["ownername"] = ownerName
        dict["datetaken"] = dateTaken
        dict["description"] = description
        return dict
    }
    
    static func decode(object: Any) -> Photo {
        let dict = HG.decode(hgdict: object, decoder: Photo.self)
        let id = dict["id"].string
        let owner = dict["owner"].string
        let secret = dict["secret"].string
        let server = dict["server"].string
        let farm = dict["farm"].int
        let title = dict["title"].string
        let ispublic = dict["ispublic"].bool
        let isfriend = dict["isfriend"].bool
        let isfamily = dict["isfamily"].bool
        let ownerName = dict["ownername"].string
        let dateTaken = dict["datetaken"].checkDate
        let description = dict["description"].dict["_content"].string(withDefault: "Not provided")
        return Photo(id: id,
                     owner: owner,
                     secret: secret,
                     server: server,
                     farm: farm,
                     title: title,
                     ispublic: ispublic,
                     isfriend: isfriend,
                     isfamily: isfamily,
                     ownerName: ownerName,
                     dateTaken: dateTaken,
                     description: description)
    }
    
    static func decode(object: Any) -> [Photo] {
        let dict = HG.decode(hgdict: object, decoder: Photo.self)
        let photoDict = dict["photos"].dict
        let photos = photoDict["photo"].array
        var pArray: [Photo] = []
        for photo in photos {
            let p: Photo = decode(object: photo)
            pArray.append(p)
        }
        return pArray
    }
    
}
