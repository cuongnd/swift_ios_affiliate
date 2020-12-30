//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import ObjectMapper
import Foundation
class ObjectMapperFrontendCart: Mappable{
    var _id: String?
    var cat_id: String?
    var sub_cat_id: String?
    var original_price: Int64?
    var unit_price: Int64?
    var name: String?
    var image: String?
    var discount_amount: Int64?
    var currency_symbol: String?
    var discount_percent: Int64?
    var color_id: String?
    var color_name: String?
    var quality: String?
    
    
    required init?(map: Map) {
        
    }
    // Mappable
    func mapping(map: Map) {
        _id <- map["_id"]
        cat_id <- map["cat_id"]
        sub_cat_id <- map["sub_cat_id"]
        original_price <- map["original_price"]
        unit_price  <- map["unit_price"]
        name  <- map["name"]
        discount_amount <- map["discount_amount"]
        currency_symbol <- map["currency_symbol"]
        discount_percent <- map["discount_percent"]
        color_id <- map["color_id"]
        color_name <- map["color_name"]
        quality <- map["quality"]
    }
}
