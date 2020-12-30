//
//  Cart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/4/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import SQLite
import Foundation
class ADRFrontEndModelCartItems: ADRModel {
    
    static func getList() -> AnySequence<Row>? {
        return ADRTableCart.shared.queryAll()
    }
    static func getAttributeListByCartId(cart_id:Int64) -> AnySequence<Row>? {
        return ADRTableCartAttribute.shared.getAttributeListByCartId(cart_id: cart_id)
    }
    
    
}
