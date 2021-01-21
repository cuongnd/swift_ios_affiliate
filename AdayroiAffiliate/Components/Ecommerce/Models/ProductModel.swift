//
//  ObjectMapperFrontendCart.swift
//  AdayroiVendor
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct ProductModel: Codable {
    let _id: String
    let cat_id: String
    let sub_cat_id: String
    var is_discount: Int
    let is_featured: Int
    let code: String
    let name: String
    let alias: String
    let product_unit: String
    let search_tag: String
    let original_price: Double
    let unit_price: Double
    let length: Double?
    let height: Double?
    let width: Double?
    let weight: Double?
    let discount_percent: Int
    let discount_value: Double
    let commistion: Double
    let productShortDescription: String?
    let productFullDescription: String?
    let subCategory: SubCategoryModel?
    let category: CategoryModel?
    let default_photo: ImageModel?
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
        case length = "length"
        case height = "height"
        case width = "width"
        case weight = "weight"
        case productShortDescription = "productShortDescription"
        case productFullDescription = "productFullDescription"
        case product_unit = "product_unit"
        case search_tag = "search_tag"
        case original_price = "original_price"
        case unit_price = "unit_price"
        case discount_percent =  "discount_percent"
        case discount_value =  "discount_value"
        case commistion = "commistion"
        case default_photo = "default_photo"
        case subCategory = "subcategory"
        case category = "category"
        case colors = "colors"
        case attributesHeader = "attributes_header"
    }
    init() {
        _id = ""
        cat_id = ""
        sub_cat_id = ""
        is_discount = 1
        is_featured = 0
        code = ""
        name = ""
        alias = ""
        length = 0.0
        height = 0.0
        width = 0.0
        weight = 0.0
        product_unit = ""
        search_tag = ""
        productShortDescription = ""
        productFullDescription = ""
        original_price = 0.0
        unit_price = 0.0
        discount_percent = 0
        discount_value = 0.0
        commistion=0.0
        default_photo=ImageModel()
        category=CategoryModel()
        subCategory=SubCategoryModel()
        colors=[ColorModel]()
        attributesHeader=[AttributesHeaderModel]()
    }
}
