//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct AttributesDetailModel: Codable {
    let _id: String
    let name: String
    let product_id: String
    let header_id: String
    let additional_price: Double?
    
   
   
    
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case name = "name"
        case product_id = "product_id"
        case header_id = "header_id"
        case additional_price = "additional_price"
       
        
    }
    init() {
        _id = ""
        name = ""
        product_id = ""
        header_id = ""
        additional_price = 0.0
       
    }
}
