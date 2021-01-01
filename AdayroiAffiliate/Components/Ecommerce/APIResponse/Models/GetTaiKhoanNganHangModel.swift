//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct GetTaiKhoanNganHangModel: Codable {
    let result: String
    let code: Int=200
    let taiKhoanNganHangModel: TaiKhoanNganHangModel
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case code = "code"
        case taiKhoanNganHangModel = "data"
    }
}
