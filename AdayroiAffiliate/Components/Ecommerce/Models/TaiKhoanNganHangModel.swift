//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct TaiKhoanNganHangModel: Codable {
    let _id: String
    let user_id: String
    let bank_account_name: String
    let bank_name: String
    let bank_account_number: String
    let bank_branch: String
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case user_id = "user_id"
        case bank_account_name = "bank_account_name"
        case bank_name = "bank_name"
        case bank_account_number = "bank_account_number"
        case bank_branch = "bank_branch"
    }
}
