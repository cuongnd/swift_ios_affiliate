//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderDataUpload: Codable {
    let user_id: String
    let sub_total_amount: String
    let discountAmount: String
    let tax_amount: String
    let shipping_amount: String
    let balance_amount: String
    let total_item_amount: String
    let contact_name: String
    let is_cod: String
    let is_bank: String
    let payment_method_nonce: String
    let trans_status_id: String
    let currency_symbol: String
    let currency_short_form: String
    let billing_fullname: String
    let billing_company: String
    let billing_address_1: String
    let billing_address_2: String
    let billing_country: String
    let billing_state: String
    let billing_city: String
    let billing_postal_code: String
    let billing_email: String
    let billing_phone: String
    let shipping_fullname: String
    let shipping_company: String
    let shipping_address_1: String
    let shipping_address_2: String
    let shipping_country: String
    let shipping_state: String
    let shipping_city: String
    let shipping_postal_code: String
    let shipping_email: String
    let shipping_phone: String
    let shipping_tax_percent: String
    let tax_percent: String
    let shipping_method_amount: String
    let shipping_method_name: String
    let payment_method_id: String
    let payment_method_amount: String
    let payment_method_name: String
    let payment_type: String
    let payment_discount_percent: String
    let memo: String
    let total_item_count: String
    let is_zone_shipping: String
    let details: [CartOrderProduct]
    
    
    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case sub_total_amount = "sub_total_amount"
        case discountAmount = "discountAmount"
        case tax_amount = "tax_amount"
        case shipping_amount = "shipping_amount"
        case balance_amount = "balance_amount"
        case total_item_amount = "total_item_amount"
        case contact_name = "contact_name"
        case is_cod = "is_cod"
        case is_bank = "is_bank"
        case payment_method_nonce = "payment_method_nonce"
        case trans_status_id = "trans_status_id"
        case currency_symbol = "currency_symbol"
        case currency_short_form = "currency_short_form"
        case billing_fullname = "billing_fullname"
        case billing_company = "billing_company"
        case billing_address_1 = "billing_address_1"
        case billing_address_2 = "billing_address_2"
        case billing_country = "billing_country"
        case billing_state = "billing_state"
        case billing_city = "billing_city"
        case billing_postal_code = "billing_postal_code"
        case billing_email = "billing_email"
        case billing_phone = "billing_phone"
        case shipping_fullname = "shipping_fullname"
        case shipping_company = "shipping_company"
        case shipping_address_1 = "shipping_address_1"
        case shipping_address_2 = "shipping_address_2"
        case shipping_country = "shipping_country"
        case shipping_state = "shipping_state"
        case shipping_city = "shipping_city"
        case shipping_postal_code = "shipping_postal_code"
        case shipping_email = "shipping_email"
        case shipping_phone = "shipping_phone"
        case shipping_tax_percent = "shipping_tax_percent"
        case tax_percent = "tax_percent"
        case shipping_method_amount = "shipping_method_amount"
        case shipping_method_name = "shipping_method_name"
        case payment_method_id = "payment_method_id"
        case payment_method_amount = "payment_method_amount"
        case payment_method_name = "payment_method_name"
        case payment_type = "payment_type"
        case payment_discount_percent = "aaaaaaa"
        case memo = "memo"
        case total_item_count = "total_item_count"
        case is_zone_shipping = "is_zone_shipping"
        case details = "details"
       
    }
}
