//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderColorModel: Codable {
    let color_id: String
    let name: String
    let value: String
    let image: String
    init() {
        color_id = ""
        name = ""
        value=""
        image=""
    }
    enum CodingKeys: String, CodingKey {
        case color_id = "color_id"
        case name = "name"
        case value = "value"
        case image = "image"
        
    }
}
