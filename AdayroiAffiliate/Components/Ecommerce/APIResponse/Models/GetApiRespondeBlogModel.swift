//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct GetApiRespondeBlogModel: Codable {
    let result: String
    let code: Int
    let errorMessage:String
    let blog: BlogModel
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case code = "code"
        case errorMessage = "errorMessage"
        case blog = "data"
    }
}
