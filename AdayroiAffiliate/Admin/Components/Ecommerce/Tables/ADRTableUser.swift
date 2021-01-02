//
//  ADRTableCart.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/5/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import SQLite
import SwiftyJSON
import Foundation
class ADRTableUser: ADRTable{
    static let shared: ADRTableUser = {
        let instance = ADRTableUser()
        // Setup code
        return instance
    }()
    public var context: String = "ADRTableUser"
    public var table: Table = Table("ADRTableUser")
    
    private let id=Expression<Int64>("id")
    private let user_id=Expression<String>("user_id")
    private let username=Expression<String>("username")
    private let active=Expression<Int64>("active")
    private let code=Expression<String>("code")
    private let phonenumber=Expression<String>("phonenumber")
    private let userToken=Expression<String>("userToken")
    private let email=Expression<String>("email")
    private let refreshToken=Expression<String>("refreshToken")
    private let password=Expression<String>("password")
    private let role=Expression<String>("role")
   
    override public   init(){
        super.init()
        do{
            if let connection=Database.shared.connection{
                try connection.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block:{ (table) in
                    table.column(self.id,primaryKey: true)
                    
                    
                    
                    table.column(self.user_id)
                    table.column(self.username)
                    table.column(self.active)
                    table.column(self.code)
                    table.column(self.phonenumber)
                    table.column(self.userToken)
                    table.column(self.email)
                    table.column(self.refreshToken)
                    table.column(self.role)
                   
                    
                    
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
        user_id:String,
        username:String,
        active:Int64,
        code:String,
        phonenumber:String,
        userToken:String,
        email:String,
        refreshToken:String,
        role:String
       
    ) -> Int64? {
        do{
            let insert=table.insert(
                self.user_id<-user_id,
                self.username<-username,
                self.active<-active,
                self.code<-code,
                self.phonenumber<-phonenumber,
                self.userToken<-userToken,
                self.email<-email,
                self.refreshToken<-refreshToken,
                self.role<-role
               
            )
            let insertId=try Database.shared.connection!.run(insert)
            return insertId
        }catch{
            let nsError=error as NSError
            print("insert new table user error. Eoverride error is \(nsError), \(nsError.userInfo)")
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
    
    func getUserInfoByUserId(user_id:String)->Row!{
        do{
            let filter=(self.user_id == user_id)
            var row:AnySequence<Row>=try Database.shared.connection?.prepare(table.filter(filter)) as! AnySequence<Row>
            let first_row = row.first(where: { (a_row) -> Bool in
                return true
            })
            return first_row
            
        }catch{
            let nsError=error as NSError
            print("get row user error. Eoverride rror is \(nsError), \(nsError.userInfo)")
        }
        
        return nil
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
