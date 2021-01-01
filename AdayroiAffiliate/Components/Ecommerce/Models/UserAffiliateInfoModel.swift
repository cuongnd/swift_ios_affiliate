//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct UserAffiliateInfoModel: Codable {
    let user_id: String
    let total: Float
    let total_processing: Float
    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case total = "total"
        case total_processing = "total_processing"
    }
    init() {
        user_id=""
        total=0.0
        total_processing=0.0
    }
}
