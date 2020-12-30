//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderUserModel: Codable {
    let user_id: String
    let active: Int64
    let modify_date: String
    let phonenumber: String
    let fullname: String
    let email: String
    let profile_image: String
    let username: String
    enum CodingKeys: String, CodingKey {
        case user_id = "_id"
        case active = "active"
        case modify_date = "modify_date"
        case phonenumber = "phonenumber"
        case fullname = "fullname"
        case email = "email"
        case profile_image = "profile_image"
        case username = "username"
    }
}
