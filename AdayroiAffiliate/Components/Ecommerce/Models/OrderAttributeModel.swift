//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderAttributeModel: Codable {
    var order_product_id: String=""
    var name: String=""
    var value: String=""
    var price: Float=0
    init() {
        order_product_id = ""
        name = ""
        value=""
        price=0
    }
    enum CodingKeys: String, CodingKey {
        case order_product_id = "order_product_id"
        case name = "name"
        case value = "value"
        case price = "price"
        
    }
}
