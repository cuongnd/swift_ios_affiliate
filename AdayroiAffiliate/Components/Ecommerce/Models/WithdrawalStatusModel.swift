//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct WithdrawalStatusModel: Codable {
    let _id: String
    let name: String
    let is_cancel: Int
    let is_confirm: Int
    let is_default: Int
    let can_delete: Int
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name = "name"
        case is_cancel = "is_cancel"
        case is_confirm = "is_confirm"
        case is_default = "is_default"
        case can_delete = "can_delete"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("_id", forKey: ._id)
        try container.encode("name", forKey: .name)
        try container.encode("is_cancel", forKey: .is_cancel)
        try container.encode("is_confirm", forKey: .is_confirm)
        try container.encode("is_default", forKey: .is_default)
        try container.encode("can_delete", forKey: .can_delete)
    }
    
}
