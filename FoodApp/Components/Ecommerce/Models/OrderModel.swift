//
//  ObjectMapperFrontendCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/6/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import Foundation
struct OrderModel: Codable {
    let order_id: String
    var total: Float=0
    let trans_status_title: String
    let payment_method_name: String
    let created_date: String
    let modify_date: String
    let customer_id: String
    let user_affiliate_id: String
    let utm_source: String
    let user_id: String
    let payment_method_id: String
    let order_status_id: String
    let order_number: String
    let balance_amount: Int
    let payment_type: String
    let billing_address_1: String
    let billing_address_2: String
    let billing_city: String
    let billing_company: String
    let billing_email: String
    let billing_full_name: String
    let billing_phone: String
    let billing_postal_code: String
    let contact_name: String
    let coupon_discount_amount: Int
    let currency_short_form: String
    let currency_symbol: String
    let discount_amount: Int
    let is_bank: Int
    let is_cod: Int
    let is_paypal: Int
    let is_stripe: Int
    let memo: String
    let payment_method_amount: Int
    let payment_discount_percent: Int
    let shipping_full_name: String
    let shipping_address_1: String
    let shipping_address_2: String
    let shipping_amount: String
    let shipping_city: String
    let shipping_company: String
    let shipping_email: String
    let shipping_method_amount: String
    let shipping_method_name: String
    let shipping_phone: String
    let shipping_postal_code: String
    let shipping_tax_percent: String
    let sub_total_amount: Int
    let tax_amount: Float
    let tax_percent: Int
    let total_item_count: Int
    let total_item_amount: Int
    let trans_status_id: String
    let user: OrderUserModel
    let list_product: [OrderProductModel]
    
    
    enum CodingKeys: String, CodingKey {
        case order_id = "_id"
        case total = "total"
        case trans_status_title = "trans_status_title"
        case payment_method_name = "payment_method_name"
        case created_date = "created_date"
        case modify_date = "modify_date"
        case customer_id = "customer_id"
        case user_affiliate_id = "user_affiliate_id"
        case utm_source = "utm_source"
        case user_id = "user_id"
        case payment_method_id = "payment_method_id"
        case order_status_id = "order_status_id"
        case order_number = "order_number"
        case balance_amount = "balance_amount"
        case payment_type = "payment_type"
        case billing_address_1 = "billing_address_1"
        case billing_address_2 = "billing_address_2"
        case billing_city = "billing_city"
        case billing_company = "billing_company"
        case billing_email = "billing_email"
        case billing_full_name = "billing_full_name"
        case billing_phone = "billing_phone"
        case billing_postal_code = "billing_postal_code"
        case contact_name = "contact_name"
        case coupon_discount_amount = "coupon_discount_amount"
        case currency_short_form = "currency_short_form"
        case currency_symbol = "currency_symbol"
        case discount_amount = "discount_amount"
        case is_bank = "is_bank"
        case is_cod = "is_cod"
        case is_paypal = "is_paypal"
        case is_stripe = "is_stripe"
        case memo = "memo"
        case payment_method_amount = "payment_method_amount"
        case payment_discount_percent = "payment_discount_percent"
        case shipping_full_name = "shipping_full_name"
        case shipping_address_1 = "shipping_address_1"
        case shipping_address_2 = "shipping_address_2"
        case shipping_amount = "shipping_amount"
        case shipping_city = "shipping_city"
        case shipping_company = "shipping_company"
        case shipping_email = "shipping_email"
        case shipping_method_amount = "shipping_method_amount"
        case shipping_method_name = "shipping_method_name"
        case shipping_phone = "shipping_phone"
        case shipping_postal_code = "shipping_postal_code"
        case shipping_tax_percent = "shipping_tax_percent"
        case sub_total_amount = "sub_total_amount"
        case tax_amount = "tax_amount"
        case tax_percent = "tax_percent"
        case total_item_count = "total_item_count"
        case total_item_amount = "total_item_amount"
        case trans_status_id = "trans_status_id"
        case list_product = "list_product"
        case user = "user"
        
        
    }
}
