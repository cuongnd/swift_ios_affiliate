//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import ObjectMapper
import Foundation
class ObjectMapperFrontendImage: Mappable{
    var _id: String?
    var img_parent_id: String?
    var img_path: String?
   required init?(map: Map) {
        
    }
    // Mappable
    func mapping(map: Map) {
        _id <- map["_id"]
        img_parent_id <- map["img_parent_id"]
        img_path <- map["img_path"]
    }
}
