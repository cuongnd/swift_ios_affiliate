//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct BlogSubCategoryModel: Codable {
    let _id: String
    let title: String
    let intro: String
    let full_content: String
    let published: Int
    let cat_id: String
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case title = "title"
        case intro = "intro"
        case full_content = "full_content"
        case published = "published"
        case cat_id = "cat_id"
    }
    init() {
        _id = ""
        title = ""
        intro = ""
        full_content = ""
        published=0
        cat_id=""
      
    }
}
