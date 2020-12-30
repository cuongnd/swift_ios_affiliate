//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderProductModel: Codable {
    var order_product_id: String
    var order_id: String
    var product_name: String
    var product_description: String
    var total: Float
    var quantity: Int
    var imageUrl: String
    var created_date: String
    var currency_short_form: String
    var currency_symbol: String
    var discount_amount: Float
    var discount_percent: Int
    var discount_price: Float
    var discount_value: Float
    var original_price: Float
    var unit_price: Float
    var product_id: String
    var product_unit: Float
    var shipping_cost: Float
    var list_attribute_value: [OrderAttributeModel]
    var color_id:String
    var color_value:String
    var color_image:String
    init() {
        order_product_id=""
        order_id = ""
        product_name = ""
        product_description = ""
        total = 0
        quantity = 0
        imageUrl = ""
        created_date = ""
        currency_short_form = ""
        currency_symbol = ""
        discount_amount = 0
        discount_percent = 0
        discount_price = 0
        discount_value = 0
        original_price = 0
        unit_price = 0
        product_id = ""
        product_unit = 0
        shipping_cost = 0
        list_attribute_value=[OrderAttributeModel]()
        color_id=""
        color_value=""
        color_image=""
        
    }
    
    enum CodingKeys: String, CodingKey {
        case order_product_id = "_id"
        case order_id = "order_id"
        case product_name = "product_name"
        case product_description = "product_description"
        case total = "total"
        case quantity = "quantity"
        case imageUrl = "imageUrl"
        case created_date = "created_date"
        case currency_short_form = "currency_short_form"
        case currency_symbol = "currency_symbol"
        case discount_amount = "discount_amount"
        case discount_percent = "discount_percent"
        case discount_price = "discount_price"
        case discount_value = "discount_value"
        case original_price = "original_price"
        case unit_price = "unit_price"
        case product_id = "product_id"
        case product_unit = "product_unit"
        case shipping_cost = "shipping_cost"
        case color_id = "color_id"
        case color_value = "color_value"
        case color_image = "color_image"
        case list_attribute_value = "list_attribute_value"
        
    }
}
