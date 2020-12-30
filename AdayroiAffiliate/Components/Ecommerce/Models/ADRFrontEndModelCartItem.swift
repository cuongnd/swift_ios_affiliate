//
//  Cart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/4/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import SQLite
import Foundation
import SwiftyJSON
class ADRFrontEndModelCartItem: ADRModel {
    static let shared: ADRFrontEndModelCartItem = {
        let instance = ADRFrontEndModelCartItem()
        // Setup code
        return instance
    }()
    private override init() {}
    func DeleteCartItem(id:Int64){
        ADRTableCart.shared.DeleteCartItem(id:id)
    }
    
    func updateCartItemByProductIdAndAttributes(product_id:String,color_id:String,attributesFilter: [String:String],plus:Int64) -> Void {
        ADRTableCart.shared.updateCartItemByProductIdAndAttributes(product_id: product_id, color_id: color_id, attributesFilter: attributesFilter, plus: plus)
    }
    func minesCartItem(cart_id:Int64, mines:Int64) -> Void {
        ADRTableCart.shared.minesCartItem(cart_id: cart_id, mines: mines)
    }
    func plusCartItem(cart_id:Int64, plus:Int64) -> Void {
        ADRTableCart.shared.plusCartItem(cart_id: cart_id, plus: plus)
    }
    func addToCcart(objectMapperFrontendProduct:ObjectMapperFrontendProduct,attributes:  [String: JSON],color:JSON,attributesFilter: [String:String],quanlity:Int64) -> Void {
        var color_id:String = color["_id"].stringValue
        let items:AnySequence<Row> = ADRTableCart.shared.getItemByProductIdAndAttributes(product_id:objectMapperFrontendProduct._id!,color_id:color_id,attributesFilter: attributesFilter )!
        let total:Int=ADRTableCart.shared.getCountItemByProductIdAndAttributes(product_id: objectMapperFrontendProduct._id!,color_id:color_id,attributesFilter: attributesFilter)!
        if(total>0){
            ADRTableCart.shared.updateCartItemByProductIdAndAttributes(product_id: objectMapperFrontendProduct._id!,color_id:color_id,attributesFilter:attributesFilter,plus: quanlity)
        }else{
            ADRTableCart.shared.insert(
                product_id: objectMapperFrontendProduct._id!,
                cat_id: objectMapperFrontendProduct.cat_id!,
                sub_cat_id: objectMapperFrontendProduct.sub_cat_id!,
                original_price: objectMapperFrontendProduct.original_price!,
                unit_price: objectMapperFrontendProduct.unit_price!,
                name: objectMapperFrontendProduct.name!,
                image: (objectMapperFrontendProduct.default_photo?.img_path!)!,
                discount_amount: objectMapperFrontendProduct.discount_amount!,
                currency_symbol: objectMapperFrontendProduct.currency_symbol!,
                discount_percent: objectMapperFrontendProduct.discount_percent!,
                color_id:color["_id"].stringValue,
                color_name: color["name"].stringValue,
                color_value: color["value"].stringValue,
                color_image: color["img_url"].stringValue,
                
                quality: quanlity,
                attributes:attributes,
                attributesFilter:attributesFilter
            )
        }
        
        
    }
    
}
