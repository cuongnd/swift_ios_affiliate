//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct CategoryModel: Codable {
    let _id: String
    let name: String
    let status: Bool
    let added_date: String
    let added_user_id: String
    let updated_date: String?=""
    let updated_user_id: String
    let ordering: Int
    let alias: String
    let description: String
    let default_photo: ImageModel
    let default_icon: ImageModel
   
    
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case name = "name"
        case status = "status"
        case added_date = "added_date"
        case added_user_id = "added_user_id"
        case updated_date = "updated_date"
        case updated_user_id = "updated_user_id"
        case ordering = "ordering"
        case alias = "alias"
        case description = "description"
        case default_photo =  "default_photo"
        case default_icon = "default_icon"
    }
}
