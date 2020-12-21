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
    private let shipping_fullname=Expression<String>("shipping_fullname")
    private let shipping_email=Expression<String>("shipping_email")
    private let shipping_phone=Expression<String>("shipping_phone")
    private let shipping_address_1=Expression<String>("shipping_address_1")
    private let shipping_address_2=Expression<String>("shipping_address_2")
    private let billing_fullname=Expression<String>("billing_fullname")
    private let billing_email=Expression<String>("billing_email")
    private let billing_phone=Expression<String>("billing_phone")
    private let billing_address_1=Expression<String>("billing_address_1")
    private let billing_address_2=Expression<String>("billing_address_2")
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
                    table.column(self.shipping_fullname)
                    table.column(self.shipping_email)
                    table.column(self.shipping_phone)
                    table.column(self.shipping_address_1)
                    table.column(self.shipping_address_2)
                    table.column(self.billing_fullname)
                    table.column(self.billing_email)
                    table.column(self.billing_phone)
                    table.column(self.billing_address_1)
                    table.column(self.billing_address_2)
                    
                    
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
    func updateShippingAndBilldingInfo(
        user_id:String,
        shipping_fullname:String,
        shipping_email:String,
        shipping_phone:String,
        shipping_address_1:String,
        shipping_address_2:String,
        billing_fullname:String,
        billing_email:String,
        billing_phone:String,
        billing_address_1:String,
        billing_address_2:String)->Bool{
        do{
            let filter=(self.user_id==user_id)
            let update_table=table.filter(filter).update(
                self.shipping_address_1<-shipping_address_1,
                self.shipping_address_2<-shipping_address_2,
                self.billing_fullname<-billing_fullname,
                self.billing_email<-billing_email,
                self.billing_phone<-billing_phone,
                self.billing_address_1<-billing_address_1,
                self.billing_address_2<-billing_address_2
            )
            let update=try Database.shared.connection!.run(update_table)
            return true
        }catch{
            let nsError=error as NSError
            print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
            return false
        }
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
        role:String,
        shipping_fullname:String,
        shipping_email:String,
        shipping_phone:String,
        shipping_address_1:String,
        shipping_address_2:String,
        billing_fullname:String,
        billing_email:String,
        billing_phone:String,
        billing_address_1:String,
        billing_address_2:String
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
                self.role<-role,
                self.shipping_fullname<-shipping_fullname,
                self.shipping_email<-shipping_email,
                self.shipping_phone<-shipping_phone,
                self.shipping_address_1<-shipping_address_1,
                self.shipping_address_2<-shipping_address_2,
                self.billing_fullname<-billing_fullname,
                self.billing_email<-billing_email,
                self.billing_phone<-billing_phone,
                self.billing_address_1<-billing_address_1,
                self.billing_address_2<-billing_address_2
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
