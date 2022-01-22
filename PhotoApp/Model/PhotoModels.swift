//
//  PhotoModels.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import Foundation

struct PhotoDataModel:Decodable{
    var photoData: Objects!
    init(photos: Objects? = nil){
        
        if photos == nil{
          return
        }
        self.photoData = photos!
    }
    var uid: Int {
        return  self.photoData.id!
    }
    
    var fullImage: String {
        if self.photoData.full == "" || self.photoData.full == nil{
            return  "noimage"
        }
       return  Constants.mediaURL + self.photoData.full!
    }
    var thumbImage: String {
        if self.photoData.thumbnail == "" || self.photoData.thumbnail == nil{
            return  "noimage"
        }
       return  Constants.mediaURL + self.photoData.thumbnail!
    }
    
}

struct PhotoList : Decodable {
    var meta : Meta
    var objects : [Objects]

    enum CodingKeys: String, CodingKey {

        case meta = "meta"
        case objects = "objects"
    }
}

struct Meta : Codable {
    let limit : Int?
    let next : String?
    let offset : Int?
    let previous : String?
    let total_count : Int?

    enum CodingKeys: String, CodingKey {

        case limit = "limit"
        case next = "next"
        case offset = "offset"
        case previous = "previous"
        case total_count = "total_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
    }

}


struct Objects : Decodable {
    let full : String?
    let id : Int?
    let resource_uri : String?
    let thumbnail : String?
    let updated : String?

    enum CodingKeys: String, CodingKey {

        case full = "full"
        case id = "id"
        case resource_uri = "resource_uri"
        case thumbnail = "thumbnail"
        case updated = "updated"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        full = try values.decodeIfPresent(String.self, forKey: .full)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        resource_uri = try values.decodeIfPresent(String.self, forKey: .resource_uri)
//        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
//        updated = try values.decodeIfPresent(String.self, forKey: .updated)
//    }

}

