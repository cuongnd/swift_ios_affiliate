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
class ADRTableSetting: ADRTable{
    static let shared: ADRTableSetting = {
        let instance = ADRTableSetting()
        // Setup code
        return instance
    }()
    public var context: String = "ADRTableSetting"
    public var table: Table = Table("ADRTableSetting")
    
    private let id=Expression<Int64>("id")
    private let language=Expression<String>("language")
    
    override public   init(){
        super.init()
        do{
            if let connection=Database.shared.connection{
                try connection.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block:{ (table) in
                    table.column(self.id,primaryKey: true)
                    table.column(self.language)
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
        language:String
    ) -> Int64? {
        do{
            let insert=table.insert(
                self.language<-language
                )
             let insertId=try Database.shared.connection!.run(insert)
            return insertId
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    func DeleteSetting(id:Int64)->Bool{
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
    
    
}
