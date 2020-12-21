//
//  AddtoCartVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 04/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import RxSwift
import RxCocoa
import Foundation
import Alamofire
import SlideMenuControllerSwift


class ADRFrontEndViewCheckoutSummaryVC: UIViewController {
    
    
    @IBOutlet weak var UIButtonNext: UIButton!
       @IBOutlet weak var UIButtonBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId)
       let urlStringPostUpdateUser = API_URL + "/api/users/\(user_id)"
       self.Webservice_getUserInfo(url: urlStringPostUpdateUser, params: [:])

        

        
    }
    @IBAction func UIButtonTouchUpInsideNext(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ADRFrontEndViewCheckoutPaymentVC") as! ADRFrontEndViewCheckoutPaymentVC
       self.navigationController?.pushViewController(vc, animated:true)
    }
    @IBAction func UIButtonTouchUpInsideBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ADRFrontEndViewCheckoutVC") as! ADRFrontEndViewCheckoutVC
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
extension ADRFrontEndViewCheckoutSummaryVC
{
    
    func Webservice_getUserInfo(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getUserResponseModel = try jsonDecoder.decode(GetUserResponseModel.self, from: jsonResponse!)
                    let userModel:UserModel=getUserResponseModel.user
                  print("userModel:\(userModel)")
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                    
            }
        }
        
        
        
    }
    func Webservice_getUpdateUser(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                     let data = jsonResponse!["data"].dictionaryValue
                     let vc = self.storyboard?.instantiateViewController(identifier: "ADRFrontEndViewCheckoutSummaryVC") as! ADRFrontEndViewCheckoutSummaryVC
                     self.navigationController?.pushViewController(vc, animated:true)
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    
    
}
