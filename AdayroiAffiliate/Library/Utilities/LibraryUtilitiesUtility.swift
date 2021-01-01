//
//  Utilities.swift
//  AdayroiAffiliate
//
//  Created by MAC OSX on 12/8/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import UIKit
import TLCustomMask
import Foundation
import AnyFormatKit
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
    
    static func format_currency(amount: UInt64, decimalCount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "VI_VN")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimalCount
        formatter.numberStyle = .currency

        let value = Double(amount) / pow(Double(10), Double(decimalCount))
        let fallback = String(format: "%.0f", value)
        return formatter.string(from: NSNumber(value: value)) ?? fallback
    }
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
