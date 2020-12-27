//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct WithdrawalStatusModel: Codable {
    let _id: String
    let name: String
    let is_confirm: Int
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name = "name"
        case is_confirm = "is_confirm"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("_id", forKey: ._id)
        try container.encode("name", forKey: .name)
        try container.encode("is_confirm", forKey: .is_confirm)
    }
    
}
