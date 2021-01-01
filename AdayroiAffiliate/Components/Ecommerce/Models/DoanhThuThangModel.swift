//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct DoanhThuThangModel: Codable {
    let month: Int
    var total: Double=0
    enum CodingKeys: String, CodingKey {
        case month = "month"
        case total = "total"
    }
}
