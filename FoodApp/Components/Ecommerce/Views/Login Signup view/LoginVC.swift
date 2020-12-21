//
//  LoginVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 04/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SlideMenuControllerSwift
import iOSDropDown
import LanguageManager_iOS

class LoginVC: UIViewController {
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var btn_showPassword: UIButton!
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_Skip: UIButton!
    @IBOutlet weak var dropDown : DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_login.setTitle("Login".localiz(), for: .normal)
        btn_Skip.setTitle("SKIP".localiz(), for: .normal)
        dropDown.placeholder="Change language".localiz()
        txt_Password.placeholder="Password".localiz()
        cornerRadius(viewName: self.btn_login, radius: 8.0)
        cornerRadius(viewName: self.btn_Skip, radius: 6.0)
        self.btn_showPassword.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        //        self.txt_Email.text = "Mitesh".localiz(comment: "123")
        
        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = ["Vietnamese", "English"]
        //Its Id Values and its optional
        dropDown.optionIds = [0,1]
        
        // Image Array its optional
        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
            print("change language")
            if(index==0){
                LanguageManager.shared.setLanguage(language: .vi)
            }else{
                LanguageManager.shared.setLanguage(language: .en)
            }
            UserDefaults.standard.synchronize()
            self.viewDidLoad()
            //LanguageManager.shared.defaultLanguage = .en
            //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
        }
    }
    @IBAction func btnTap_ShowPassword(_ sender: UIButton) {
        if self.btn_showPassword.image(for: .normal) == UIImage(systemName: "eye.slash.fill")
        {
            self.btn_showPassword.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            self.txt_Password.isSecureTextEntry = false
        }
        else{
            self.txt_Password.isSecureTextEntry = true
            self.btn_showPassword.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        
    }
    
    @IBAction func btnTap_Skip(_ sender: UIButton) {
        UserDefaultManager.setStringToUserDefaults(value: "1", key: UD_isSkip)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
        if UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "en" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "N/A"
        {
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
            let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
            appNavigation.setNavigationBarHidden(true, animated: true)
            let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sideMenuViewController)
            slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
            slideMenuController.removeLeftGestures()
            UIApplication.shared.windows[0].rootViewController = slideMenuController
        }
        else
        {
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
            let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
            appNavigation.setNavigationBarHidden(true, animated: true)
            let slideMenuController = SlideMenuController(mainViewController: appNavigation, rightMenuViewController: sideMenuViewController)
            slideMenuController.changeRightViewWidth(UIScreen.main.bounds.width * 0.8)
            slideMenuController.removeRightGestures()
            UIApplication.shared.windows[0].rootViewController = slideMenuController
        }
    }
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension LoginVC
{
    @IBAction func btnTap_forgotPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPassword") as! ForgotPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_Signup(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTap_Login(_ sender: UIButton) {
        let urlString = API_URL + "/api_task/users.login"
        let params: NSDictionary = [
            "username":self.txt_username.text!,
            "password":self.txt_Password.text!,
            "token":UserDefaultManager.getStringFromUserDefaults(key: UD_fcmToken)
        ]
        self.Webservice_Login(url: urlString, params: params)
    }
    
}
extension LoginVC
{
    func Webservice_Login(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let userData = jsonResponse!["data_user"].dictionaryValue
                    print("userData: \(userData)")
                    let userId = userData["_id"]!.stringValue
                    UserDefaultManager.setStringToUserDefaults(value: userId, key: UD_userId)
                    UserDefaultManager.setStringToUserDefaults(value: "", key: UD_isSkip)
                    
                    ADRTableUser.shared.insert(
                        user_id:userData["_id"]!.stringValue,
                        username:userData["username"]!.stringValue,
                        active:Int64(userData["active"]!.intValue),
                        code:userData["code"]!.stringValue,
                        phonenumber:userData["phonenumber"]!.stringValue,
                        userToken:userData["userToken"]!.stringValue,
                        email:userData["email"]!.stringValue,
                        refreshToken:userData["refreshToken"]!.stringValue,
                        role:userData["role"]!.stringValue,
                        shipping_fullname:userData["shipping_fullname"]!.stringValue,
                        shipping_email:userData["shipping_email"]!.stringValue,
                        shipping_phone:userData["shipping_phone"]!.stringValue,
                        shipping_address_1:userData["shipping_address_1"]!.stringValue,
                        shipping_address_2:userData["shipping_address_2"]!.stringValue,
                        billing_fullname:userData["billing_fullname"]!.stringValue,
                        billing_email:userData["billing_email"]!.stringValue,
                        billing_phone:userData["billing_phone"]!.stringValue,
                        billing_address_1:userData["billing_address_1"]!.stringValue,
                        billing_address_2:userData["billing_address_2"]!.stringValue
                        
                    )
                    if UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "vi" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "N/A"
                    {
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                        appNavigation.setNavigationBarHidden(true, animated: true)
                        let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sideMenuViewController)
                        slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
                        slideMenuController.removeLeftGestures()
                        UIApplication.shared.windows[0].rootViewController = slideMenuController
                    }
                    else 
                    {
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                        appNavigation.setNavigationBarHidden(true, animated: true)
                        let slideMenuController = SlideMenuController(mainViewController: appNavigation, rightMenuViewController: sideMenuViewController)
                        slideMenuController.changeRightViewWidth(UIScreen.main.bounds.width * 0.8)
                        slideMenuController.removeRightGestures()
                        UIApplication.shared.windows[0].rootViewController = slideMenuController
                    }
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["errorMessage"].stringValue)
                }
            }
        }
    }
}
