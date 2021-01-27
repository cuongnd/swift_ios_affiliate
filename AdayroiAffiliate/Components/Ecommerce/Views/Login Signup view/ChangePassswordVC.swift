//
//  ChangePassswordVC.swift
//  AdayroiAffiliate
//
//  Created by Mitesh's MAC on 15/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
class ChangePassswordVC: UIViewController {
    @IBOutlet weak var btn_Reset: UIButton!
    @IBOutlet weak var txt_confirmPassword: UITextField!
    @IBOutlet weak var txt_NewPassword: UITextField!
    @IBOutlet weak var txt_oldPassword: UITextField!
    
    @IBOutlet weak var lbl_titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_titleLabel.text = "Change Password".localiz()
        self.btn_Reset.setTitle("Reset".localiz(), for: .normal)
        cornerRadius(viewName: self.btn_Reset, radius: 8)
    }
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_Reset(_ sender: UIButton) {
        if self.txt_oldPassword.text! == "" || self.txt_NewPassword.text == "" || self.txt_confirmPassword.text! == "" {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Please enter all details".localiz())
        }
        else if self.txt_NewPassword.text! != self.txt_confirmPassword.text! {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "New password & Confirm password must be same".localiz())
        }
        else {
            let urlString = API_URL + "/api_task/users.change_password_user_affiliate_info"
            let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                                        "old_password":self.txt_oldPassword.text!,
                                        "new_password":self.txt_NewPassword.text!]
            self.Webservice_ChangePassword(url: urlString, params: params)
        }
    }
}
//MARK: Webservices
extension ChangePassswordVC
{
    func Webservice_ChangePassword(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
                   if strErrorMessage.count != 0 {
                       showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
                   }
                   else {
                       print(jsonResponse!)
                       do {
                           let jsonDecoder = JSONDecoder()
                           let getApiRespondeUserChangePassword = try jsonDecoder.decode(GetApiRespondeUserChangePassword.self, from: jsonResponse!)
                           if(getApiRespondeUserChangePassword.result=="success"){
                            self.navigationController?.popViewController(animated: true)
                            showAlertMessage(titleStr: "Thông báo", messageStr: "Cập nhật password thành công")
                           }else{
                            showAlertMessage(titleStr: "Có lỗi", messageStr: getApiRespondeUserChangePassword.errorMessage)
                            }
                           
                       } catch let error as NSError  {
                           print("url \(url)")
                           print("error : \(error)")
                           showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Có lỗi phát sinh")
                           
                       }
                       
                       
                       //print("userModel:\(userModel)")
                       
                   }
               }
        
        
       
    }
}
