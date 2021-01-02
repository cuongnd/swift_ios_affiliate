//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct AttributesHeaderModel: Codable {
    let _id: String
    let name: String
    let product_id: String
    let attributesDetail: [AttributesDetailModel]?
    
   
   
    
    enum CodingKeys: String, CodingKey {
       case _id = "_id"
        case name = "name"
        case product_id = "product_id"
        case attributesDetail = "attributes_detail"
       
        
    }
    init() {
        _id = ""
        name = ""
        product_id = ""
        attributesDetail = [AttributesDetailModel]()
       
    }
}
