//
//  ObjectMapperFrontendCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct HieuQuaDonHangModel: Codable {
    let cancel_percent: Double
    let pending_percent: Double
    let completed_percent: Double
    let in_process_percent: Double
    enum CodingKeys: String, CodingKey {
        case cancel_percent = "cancel_percent"
        case pending_percent = "pending_percent"
        case completed_percent = "completed_percent"
        case in_process_percent = "in_process_percent"
    }
}
