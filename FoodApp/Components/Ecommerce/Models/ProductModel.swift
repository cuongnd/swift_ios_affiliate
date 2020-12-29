//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct ProductModel: Codable {
    let _id: String
    let cat_id: String
    let sub_cat_id: String
    let is_discount: Int?=0
    let is_featured: Int?=0
    let code: String?=""
    let name: String
    let alias: String?=""
    let search_tag: String?=""
    let original_price: Double
    let unit_price: Double
    let discount_percent: Int?=0
    let discount_value: Double?=0.0
    let commistion: Double
    let default_photo: ImageModel
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case cat_id = "cat_id"
        case sub_cat_id = "sub_cat_id"
        case is_discount = "is_discount"
        case is_featured = "is_featured"
        case code = "code"
        case name = "name"
        case alias = "alias"
        case search_tag = "search_tag"
        case original_price = "original_price"
        case unit_price = "unit_price"
        case discount_percent =  "discount_percent"
        case discount_value =  "discount_value"
        case commistion = "commistion"
        case default_photo = "default_photo"
    }
}
