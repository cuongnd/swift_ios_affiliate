//
//  Factory.swift
//  EcommerceApp
//
//  Created by Macbook on 4/19/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import UIKit
import Material
class Factory {
    static func getUser() -> User {
        var user: User
        user = User(id:"")
        let preferentces=UserDefaults.standard
        if(preferentces.object(forKey: "user") != nil){
            let  str_user:String=preferentces.value(forKey: "user")! as! String
            if !str_user.isEmpty {
                var dictonary:NSDictionary?
                
                if let data = str_user.data(using: String.Encoding.utf8) {
                    
                    do {
                        dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                        
                        if let myDictionary = dictonary
                        {
                            user = User(id:myDictionary["_id"] as! String)
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }

                
                
              
            }
        }
        return user
    }
}
