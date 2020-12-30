//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct GetOrderResponseModel: Codable {
    let result: String
    let code: Int
    let order: OrderModel
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case code = "code"
        case order = "data"
    }
}
