//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderCustomerModel: Codable {
    let customer_id: String
    let full_name: String
    let phone_number: String
    let email: String
    let address1: String
    let address2: String
    init() {
        customer_id = ""
        full_name = ""
        phone_number=""
        email=""
        address1=""
        address2=""
    }
    enum CodingKeys: String, CodingKey {
        case customer_id = "_id"
        case full_name = "full_name"
        case phone_number = "phone_number"
        case email = "email"
        case address1 = "address1"
        case address2 = "address2"
        
    }
}
