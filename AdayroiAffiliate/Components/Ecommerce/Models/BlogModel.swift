//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct BlogModel: Codable {
    let _id: String
    let alias: String?
    let published: Int
    let start_date: String?
    let end_date: String?
    let full_content: String
    let sub_cat_id: String
    var title:String
    let intro:String
    let image_intro:ImageModel?
    let blogSubCategory:BlogSubCategoryModel?
   
   
    
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case alias = "alias"
        case published = "published"
        case start_date = "start_date"
        case end_date = "end_date"
        case full_content = "full_content"
        case sub_cat_id = "sub_cat_id"
        case title = "title"
        case intro = "intro"
        case image_intro = "image_intro"
        case blogSubCategory = "blogsubcategory"
        
    }
    init() {
        _id = ""
        alias = ""
        published = 0
        start_date = ""
        end_date=""
        full_content=""
        sub_cat_id=""
        title=""
        intro=""
        image_intro = ImageModel()
        blogSubCategory=BlogSubCategoryModel()
      
    }
}
