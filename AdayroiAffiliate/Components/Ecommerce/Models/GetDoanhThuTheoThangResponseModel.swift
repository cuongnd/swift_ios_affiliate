//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct GetDoanhThuTheoThangResponseModel: Codable {
    let result: String
    let errorMessage: String
    let code: Int
    let list_doanhthu: [DoanhThuThangModel]
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case errorMessage = "errorMessage"
        case code = "code"
        case list_doanhthu = "data"
    }
}
