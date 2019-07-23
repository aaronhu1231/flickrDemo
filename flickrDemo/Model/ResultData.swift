//
//  ResultData.swift
//  flickrDemo
//
//  Created by aaron on 2019/7/22.
//  Copyright © 2019 aaron. All rights reserved.
//

import Foundation
struct photoData:Codable {
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
}

struct PhotosData:Codable{
    let photo : [photoData]
}

struct ResultData:Codable {
    let photos : PhotosData
}

