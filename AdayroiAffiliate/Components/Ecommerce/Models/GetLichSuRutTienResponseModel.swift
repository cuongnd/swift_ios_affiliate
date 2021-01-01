//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct GetLichSuRutTienResponseModel: Codable {
    let result: String
    let errorMessage: String
    let code: Int
    let rutTienList: [RutTienModel]
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case errorMessage = "errorMessage"
        case code = "code"
        case rutTienList = "data"
    }
  
}
