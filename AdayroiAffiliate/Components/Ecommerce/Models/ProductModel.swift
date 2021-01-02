//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct ProductModel: Codable {
    let _id: String
    let cat_id: String
    let sub_cat_id: String
    var is_discount: Bool
    let is_featured: Int
    let code: String
    let name: String
    let alias: String
    let search_tag: String
    let original_price: Double
    let unit_price: Double
    let discount_percent: Int
    let discount_value: Double
    let commistion: Double
    let subCategory: SubCategoryModel?
    let default_photo: ImageModel
    let colors:[ColorModel]?
    let attributesHeader:[AttributesHeaderModel]?
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
        case subCategory = "subcategory"
        case colors = "colors"
        case attributesHeader = "attributes_header"
    }
    init() {
        _id = ""
        cat_id = ""
        sub_cat_id = ""
        is_discount = false
        is_featured = 0
        code = ""
        name = ""
        alias = ""
        search_tag = ""
        original_price = 0.0
        unit_price = 0.0
        discount_percent = 0
        discount_value = 0.0
        commistion=0.0
        default_photo=ImageModel()
        subCategory=SubCategoryModel()
        colors=[ColorModel]()
        attributesHeader=[AttributesHeaderModel]()
    }
}
