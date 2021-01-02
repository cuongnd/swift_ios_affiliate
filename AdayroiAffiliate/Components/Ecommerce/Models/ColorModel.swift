//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct ColorModel: Codable {
    let _id: String
    let img_url: String
    let attribute_header_id: String
    let name: String
    let value: String
    let product_id: String
    let color_value: String
    var is_selected:Bool?
    let price:Double?
   
   
    
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case img_url = "img_url"
        case attribute_header_id = "attribute_header_id"
        case name = "name"
        case value = "value"
        case product_id = "product_id"
        case color_value = "color_value"
        case is_selected = "is_selected"
        case price = "price"
        
    }
    init() {
        _id = ""
        img_url = ""
        attribute_header_id = ""
        name = ""
        value=""
        product_id=""
        color_value=""
        is_selected=false
        price=0.0
      
    }
}
