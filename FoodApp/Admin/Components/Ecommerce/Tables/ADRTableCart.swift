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
class ADRTableCart: ADRTable{
    static let shared: ADRTableCart = {
        let instance = ADRTableCart()
        // Setup code
        return instance
    }()
    public var context: String = "ADRTableCart"
    public var table: Table = Table("ADRTableCart")
    
    private let id=Expression<Int64>("id")
    private let product_id=Expression<String>("product_id")
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
    private let color_value=Expression<String>("color_value")
    private let color_image=Expression<String>("color_image")
    private let quality=Expression<Int64>("quality")
    private let attributes_filter=Expression<String>("attributes_filter")
    override public   init(){
        super.init()
        do{
            if let connection=Database.shared.connection{
                try connection.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block:{ (table) in
                    table.column(self.id,primaryKey: true)
                    table.column(self.product_id)
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
                    table.column(self.color_value)
                    table.column(self.color_image)
                    table.column(self.quality)
                    table.column(self.attributes_filter)
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
        print("Cart detail: id=\(table[self.id]),product_id=\(table[self.product_id]), cat_id=\(table[self.cat_id]), sub_cat_id=\(table[self.sub_cat_id]), original_price=\(table[self.original_price]), unit_price=\(table[self.unit_price]),name=\(table[self.name]),image=\(table[self.image]), discount_amount=\(table[self.discount_amount]), currency_symbol=\(table[self.currency_symbol]), discount_percent=\(table[self.discount_percent]), color_id=\(table[self.color_id]), color_name=\(table[self.color_name]), quality=\(table[self.quality])")
    }
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    func insert(
        product_id:String,
        cat_id:String,
        sub_cat_id:String,
        original_price:Int64,
        unit_price:Int64,
        name:String,
        image:String,
        discount_amount:Int64,
        currency_symbol:String,
        discount_percent:Int64,
        color_id:String,
        color_name:String,
        color_value:String,
        color_image:String,
        quality:Int64,
        attributes:[String:JSON],
        attributesFilter:[String:String]
    ) -> Int64? {
        let strAttributeFilter:String=attributesFilter.description
        
        do{
            let insert=table.insert(
                self.product_id<-product_id,
                self.cat_id<-cat_id,
                self.sub_cat_id<-sub_cat_id,
                self.original_price<-original_price,
                self.unit_price<-unit_price,
                self.name<-name,
                self.image<-image,
                self.discount_amount<-discount_amount,
                self.currency_symbol<-currency_symbol,
                self.discount_percent<-discount_percent,
                self.color_id<-color_id,
                self.color_name<-color_name,
                self.color_value<-color_value,
                self.color_image<-color_image,
                self.quality<-quality,
                self.attributes_filter<-strAttributeFilter
                
            )
            let insertId=try Database.shared.connection!.run(insert)
            /*
             cart_id:Int64,
             product_id:String,
             parent_attribute_id:String,
             attribute_id:String,
             name:String,
             value:String,
             price:Float64
             */
            for attribute in attributes{
                ADRTableCartAttribute.shared.insert(
                    cart_id:insertId,
                    product_id:attribute.value["product_id"].stringValue,
                    parent_attribute_id:attribute.value["parent_attribute_id"].stringValue,
                    attribute_id:attribute.value["_id"].stringValue,
                    name:attribute.value["name"].stringValue,
                    value:attribute.value["value"].stringValue,
                    price:Float64(attribute.value["price"].floatValue)
               )
            }
            
            return insertId
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
     
    func DeleteCartItem(id:Int64)->Bool{
        do{
            let filter=table.filter(self.id==id);
            let delete=try Database.shared.connection!.run(filter.delete())
            ADRTableCartAttribute.shared.DeleteCartAttributeByCartId(cart_id: id)
            return true
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return false
        }
        
        return true;
    }
    func updateCartItemByProductIdAndAttributes(product_id:String,color_id:String,attributesFilter:[String:String],plus:Int64)->Bool{
        let strAttributeFilter:String=attributesFilter.description
        do{
            let filter=(self.product_id==product_id) && (self.color_id==color_id) && (self.attributes_filter==strAttributeFilter)
            var row:AnySequence<Row>=try Database.shared.connection?.prepare(table.filter(filter)) as! AnySequence<Row>
            let first_row = row.first(where: { (a_row) -> Bool in
                return true
            })
            var total:Int64=try first_row?.get(Expression<Int64>("quality")) as! Int64
            total=total+plus
            let update_table=table.filter(filter).update(
                self.quality<-total
            )
            let update=try Database.shared.connection!.run(update_table)
            return true
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return false
        }
        
        return true;
    }
    func minesCartItem(cart_id:Int64,mines:Int64)->Bool{
        do{
            let filter=(self.id == cart_id)
            var row:AnySequence<Row>=try Database.shared.connection?.prepare(table.filter(filter)) as! AnySequence<Row>
            let first_row = row.first(where: { (a_row) -> Bool in
                return true
            })
            var total:Int64=try first_row?.get(Expression<Int64>("quality")) as! Int64
            total=total-mines
            if(total==0){
                return true
            }
            let update_table=table.filter(filter).update(
                self.quality<-total
            )
            let update=try Database.shared.connection!.run(update_table)
            return true
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return false
        }
        
        return true;
    }
    func plusCartItem(cart_id:Int64,plus:Int64)->Bool{
           do{
               let filter=(self.id == cart_id)
               var row:AnySequence<Row>=try Database.shared.connection?.prepare(table.filter(filter)) as! AnySequence<Row>
               let first_row = row.first(where: { (a_row) -> Bool in
                   return true
               })
               var total:Int64=try first_row?.get(Expression<Int64>("quality")) as! Int64
               total=total+plus
               let update_table=table.filter(filter).update(
                   self.quality<-total
               )
               let update=try Database.shared.connection!.run(update_table)
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
    func getCountItemByProductIdAndAttributes(product_id:String,color_id:String,attributesFilter:[String:String])->Int?{
        let strAttributeFilter:String=attributesFilter.description
        do{
            let fillterCondition=(self.product_id==product_id) && (self.color_id==color_id) && (self.attributes_filter==strAttributeFilter)
            let items:AnySequence<Row> = try Database.shared.connection?.prepare(self.table.filter(fillterCondition)) as! AnySequence<Row>
            var total:Int=0;
            for item in items{
                do{
                    total=total+1;
                }catch{
                    let nsError=error as NSError
                    print("insert table Cart error. Error is \(nsError), \(nsError.userInfo)")
                }
            }
            return total
            
        }catch{
            let nsError=error as NSError
            print("insert table Cart error. Error is \(nsError), \(nsError.userInfo)")
            return 0
        }
        
        
    }
    func getItemByProductIdAndAttributes(product_id:String,color_id:String,attributesFilter:[String:String])->AnySequence<Row>?{
        let strAttributeFilter:String=attributesFilter.description
        do{
            let fillterCondition=(self.product_id==product_id) && (self.color_id==color_id) &&  (self.attributes_filter==strAttributeFilter)
            return try Database.shared.connection?.prepare(self.table.filter(fillterCondition))
        }catch{
            let nsError=error as NSError
            print("insert table Cart error. Error is \(nsError), \(nsError.userInfo)")
            return nil
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
    
    
}
