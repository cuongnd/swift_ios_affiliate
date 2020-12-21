//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct CartOrderProduct: Codable {
    let shop_id: String
    let product_id: String
    let product_name: String
    let product_attribute_id: String
    let product_attribute_name: String
    let product_attribute_price: String
    let product_color_id: String
    let product_color_code: String
    let product_unit: String
    let product_measurement: String
    let shipping_cost: String
    let unit_price: String
    let original_price: String
    let discount_price: String
    let discount_amount: String
    let qty: String
    let discount_value: String
    let discount_percent: String
    let currency_short_form: String
    let currency_symbol: String
    
    enum CodingKeys: String, CodingKey {
        case shop_id = "shop_id"
        case product_id = "product_id"
        case product_name = "product_name"
        case product_attribute_id = "product_attribute_id"
        case product_attribute_name = "product_attribute_name"
        case product_attribute_price = "product_attribute_price"
        case product_color_id = "product_color_id"
        case product_color_code = "product_color_code"
        case product_unit = "product_unit"
        case product_measurement = "product_measurement"
        case shipping_cost = "shipping_cost"
        case unit_price = "unit_price"
        case original_price = "original_price"
        case discount_price = "discount_price"
        case discount_amount = "discount_amount"
        case qty = "qty"
        case discount_value = "discount_value"
        case discount_percent = "discount_percent"
        case currency_short_form = "currency_short_form"
        case currency_symbol = "currency_symbol"
        
        
        
    }
}
