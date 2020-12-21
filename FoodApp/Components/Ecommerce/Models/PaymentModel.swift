//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct PaymentModel: Codable {
    var _id: String
    var name: String
    var default_photo: ImageModel
    var isselected:Int
    init() {
        _id = ""
        name = ""
        default_photo=ImageModel()
        isselected=1
    }
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name = "name"
        case isselected = "is_default"
        case default_photo = "default_photo"
        
    }
}
