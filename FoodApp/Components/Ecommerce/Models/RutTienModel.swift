//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct RutTienModel: Codable {
    let _id: String
    let amount: String
    let status: String=""
    let withdrawalstatus_id: String
    let withdrawalstatus: WithdrawalStatusModel=WithdrawalStatusModel()
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case amount = "amount"
        case status = "status"
        case withdrawalstatus_id = "withdrawalstatus_id"
        case withdrawalstatus = "withdrawalstatus"
    }
}
