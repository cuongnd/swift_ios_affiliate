//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
struct ObjectMapperFrontendUser: Codable {
    let facebook_id: String
    let shipping_address_1: String
    let shipping_city: String
    let billing_country: String
    let billing_phone: String
    let billing_address_1: String
    let billing_fullname: String
    let shipping_state: String
    let active: Int64
    let billing_company: String
    let modify_date: String
    let billing_state: String
    let billing_city: String
    let shipping_address_2: String
    let _id: String
    let phonenumber: String
    let fullname: String
    let billing_postal_code: String
    let email: String
    let billing_address_2: String
    let shipping_fullname: String
    let shipping_postal_code: String
    let profile_image: String
    let shipping_phone: String
    let username: String
    
    
    

    enum CodingKeys: String, CodingKey {
        case facebook_id = "facebook_id"
        case shipping_address_1 = "shipping_address_1"
        case shipping_city = "shipping_city"
        case billing_country = "billing_country"
        case billing_phone = "billing_phone"
        case billing_address_1 = "billing_address_1"
        case billing_fullname = "billing_fullname"
        case shipping_state = "shipping_state"
        case active = "active"
        case billing_company = "billing_company"
        case modify_date = "modify_date"
        case billing_state = "billing_state"
        case billing_city = "billing_city"
        case shipping_address_2 = "shipping_address_2"
        case _id = "_id"
        case phonenumber = "phonenumber"
        case fullname = "fullname"
        case billing_postal_code = "billing_postal_code"
        case email = "email"
        case billing_address_2 = "billing_address_2"
        case shipping_fullname = "shipping_fullname"
        case shipping_postal_code = "shipping_postal_code"
        case profile_image = "profile_image"
        case shipping_phone = "shipping_phone"
        case username = "username"
        
        
    }
}
