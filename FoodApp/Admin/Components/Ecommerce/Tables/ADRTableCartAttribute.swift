//
//  ADRTableCart.swift
//  FoodApp
//
//  Created by MAC OSX on 12/5/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import SQLite
import SwiftyJSON
import Foundation
class ADRTableCartAttribute: ADRTable{
    static let shared: ADRTableCartAttribute = {
        let instance = ADRTableCartAttribute()
        // Setup code
        return instance
    }()
    public var context: String = "ADRTableCartAttribute"
    public var table: Table = Table("ADRTableCartAttribute")
    private let id=Expression<Int64>("id")
    private let cart_id=Expression<Int64>("cart_id")
    private let product_id=Expression<String>("product_id")
    private let parent_attribute_id=Expression<String>("parent_attribute_id")
    private let attribute_id=Expression<String>("attribute_id")
    private let name=Expression<String>("name")
    private let value=Expression<String>("value")
    private let price=Expression<Float64>("price")
    
    override public   init(){
        super.init()
        do{
            if let connection=Database.shared.connection{
                try connection.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block:{ (table) in
                    table.column(self.id,primaryKey: true)
                    table.column(self.cart_id)
                    table.column(self.product_id)
                    table.column(self.name)
                    table.column(self.value)
                    table.column(self.parent_attribute_id)
                    table.column(self.attribute_id)
                    table.column(self.price)
                    
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
        
    }
    
    func insert(
        cart_id:Int64,
        product_id:String,
        parent_attribute_id:String,
        attribute_id:String,
        name:String,
        value:String,
        price:Float64
         ) -> Int64? {
        do{
            let insert=table.insert(
                self.cart_id<-cart_id,
                self.product_id<-product_id,
                self.parent_attribute_id<-parent_attribute_id,
                self.attribute_id<-attribute_id,
                self.name<-name,
                self.value<-value,
                self.price<-price
                
            )
            let insertId=try Database.shared.connection!.run(insert)
            return insertId
        }catch{
            let nsError=error as NSError
            print("insert new table ADRTableCartAttribute error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    func DeleteCartAttributeByCartId(cart_id:Int64)->Bool{
        do{
            let filter=table.filter(self.cart_id==cart_id);
            let delete=try Database.shared.connection!.run(filter.delete())
            return true
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return false
        }
        
        return true;
    }
    
    func queryCountAll()->Int{
        do{
            return try Database.shared.connection?.scalar(self.table.count) as! Int
        }catch{
            let nsError=error as NSError
            print("insert table Cart error. Error is \(nsError), \(nsError.userInfo)")
            return 0
        }
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
    
    func getAttributeListByCartId(cart_id:Int64) -> AnySequence<Row>? {
         let filter=table.filter(self.cart_id==cart_id);
        do{
            return try Database.shared.connection?.prepare(filter)
        }catch{
            let nsError=error as NSError
            print("insert table Cart error. Error is \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
}
