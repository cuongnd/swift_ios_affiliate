//
//  Utilities.swift
//  FoodApp
//
//  Created by MAC OSX on 12/8/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import UIKit
import Foundation
class LibraryUtilitiesUtility{
    static func redirect(navigationController:UINavigationController, view:String,layout:String) -> Void {
        //let ecommerceStoryboard = UIStoryboard(name: "ProductDetails", bundle: nil)
        //let view=ecommerceStoryboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        //navigationController.pushViewController(view, animated: true)
    }
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
