//
//  ADRProducts.swift
//  FoodApp
//
//  Created by MAC OSX on 12/5/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import SQLite
import Foundation
class ADRTableProduct:ADRTable{
       static var shared: ADRTableCart = ADRTableCart()
       public var context: String = "ADRTableProduct"
       public var table: Table = Table("ADRTableProduct")
       private let _id=Expression<String>("_id")
       private let cat_id=Expression<String>("cat_id")
       private let sub_cat_id=Expression<String>("sub_cat_id")
       private let original_price=Expression<Int64>("original_price")
       private let unit_price=Expression<Int64>("unit_price")
       private let name=Expression<String>("name")
       private let image=Expression<String>("image")
       private let discount_amount=Expression<Int64>("discount_amount")
       private let currency_symbol=Expression<String>("currency_symbol")
       private let discount_percent=Expression<Int64>("discount_percent")
       private let color_id=Expression<String>("color_id")
       private let color_name=Expression<String>("color_name")
       private let quality=Expression<Int64>("quality")
        override public   init(){
           super.init()
           do{
               if let connection=Database.shared.connection{
                   try connection.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block:{ (table) in
                       table.column(self._id,primaryKey: true)
                       table.column(self.cat_id)
                       table.column(self.sub_cat_id)
                       table.column(self.original_price)
                       table.column(self.unit_price)
                       table.column(self.name)
                       table.column(self.image)
                       table.column(self.discount_amount)
                       table.column(self.currency_symbol)
                       table.column(self.discount_percent)
                       table.column(self.color_id)
                       table.column(self.color_name)
                       table.column(self.quality)
                   }))
                   print("Create table Cart successfully")
               }else{
                   print("Create table Cart error")
               }
           } catch{
               let nsError=error as NSError
               print("Creoverride ate table Cart error. Error is \(nsError), \(nsError.userInfo)")
           }
       }
       override func toString(cart:Row) {
           print("Cart detail: _id=\(table[self._id]), cat_id=\(table[self.cat_id]), sub_cat_id=\(table[self.sub_cat_id]), original_price=\(table[self.original_price]), unit_price=\(table[self.unit_price]),name=\(table[self.name]),image=\(table[self.image]), discount_amount=\(table[self.discount_amount]), currency_symbol=\(table[self.currency_symbol]), discount_percent=\(table[self.discount_percent]), color_id=\(table[self.color_id]), color_name=\(table[self.color_name]), quality=\(table[self.quality])")
       }
       
       func queryAll() -> AnySequence<Row>? {
           do{
               return try Database.shared.connection?.prepare(self.table)
           }catch{
               let nsError=error as NSError
               print("insert table Cart error. Error is \(nsError), \(nsError.userInfo)")
               return nil
           }
       }
}
