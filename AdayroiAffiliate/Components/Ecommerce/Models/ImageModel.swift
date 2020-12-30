//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct ImageModel: Codable {
    let _id: String
    let img_parent_id: String
    let img_path: String
    init() {
        _id = ""
        img_parent_id = ""
        img_path=""
    }
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case img_parent_id = "img_parent_id"
        case img_path = "img_path"
        
    }
}
