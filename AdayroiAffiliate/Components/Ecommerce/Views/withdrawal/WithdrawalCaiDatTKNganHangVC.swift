//
//  OrderHistoryVC.swift
//  AdayroiAffiliate
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON



class WithdrawalCaiDatTKNganHangVC: UIViewController {
    
    @IBOutlet weak var btn_ok: UIButton!
    
    @IBOutlet weak var UITextFieldChuTaiKhoan: UITextField!
    @IBOutlet weak var UITextFieldNganHang: UITextField!
    @IBOutlet weak var UITextFieldSoTaiKhoan: UITextField!
    @IBOutlet weak var UITextViewChiNhanh: UITextView!
    var Note = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/banks/get_bank_info_by_user_id?user_id=\(user_id)"
        self.Webservice_GetTaiKhoanNganHang(url: urlString, params:[:])
        
    }
    
    
    @IBAction func btnTap_Ok(_ sender: UIButton) {
        
        if(UITextFieldChuTaiKhoan.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            UITextFieldChuTaiKhoan.text="";
            UITextFieldChuTaiKhoan.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập thông tin chủ tài khoản", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        if(UITextFieldNganHang.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            UITextFieldNganHang.text="";
            UITextFieldNganHang.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập tên ngân hàng", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        if(UITextFieldSoTaiKhoan.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            UITextFieldSoTaiKhoan.text="";
            UITextFieldSoTaiKhoan.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập số tài khoản", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        
        
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Bạn có chắc chắn muốn cập nhật không ?".localiz(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localiz(), style: .default) { (action) in
            
            
            let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
            let params: NSDictionary = [
                "user_id":user_id,
                "bank_account_name": self.UITextFieldChuTaiKhoan.text!,
                "bank_name": self.UITextFieldNganHang.text!,
                "bank_account_number": self.UITextFieldSoTaiKhoan.text!,
                "bank_branch": self.UITextViewChiNhanh.text!
            ]
            
            let urlStringPostUpdateTaiKhoanNganHang = API_URL + "/api_task/banks.save_bank_info_by_user_id"
            self.Webservice_getUpdateTaiKhoanNganHang(url: urlStringPostUpdateTaiKhoanNganHang, params: params)
            
            
            
        }
        let noAction = UIAlertAction(title: "No".localiz(), style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC,animated: true,completion: nil)
        
        
        
        
        
    }
    
    @IBAction func btnTap_dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func refreshData(_ sender: Any) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetTaiKhoanNganHang(url: urlString, params:[:])
        
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetTaiKhoanNganHang(url: urlString, params:[:])
        
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
        
    }
    
    
}



//MARK: WithdrawalList
extension WithdrawalCaiDatTKNganHangVC {
    
    
    func Webservice_GetTaiKhoanNganHang(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getTaiKhoanNganHangModel = try jsonDecoder.decode(GetTaiKhoanNganHangModel.self, from: jsonResponse!)
                    let taiKhoanNganHangModel=getTaiKhoanNganHangModel.taiKhoanNganHangModel
                    self.UITextFieldChuTaiKhoan.text=taiKhoanNganHangModel.bank_account_name
                    self.UITextFieldNganHang.text=taiKhoanNganHangModel.bank_name
                    self.UITextFieldSoTaiKhoan.text=taiKhoanNganHangModel.bank_account_number
                    self.UITextViewChiNhanh.text=taiKhoanNganHangModel.bank_branch
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
    }
    func Webservice_getUpdateTaiKhoanNganHang(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let updateTaiKhoanNganHangModel = try jsonDecoder.decode(UpdateTaiKhoanNganHangModel.self, from: jsonResponse!)
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Cập nhật tài khoản ngân hàng thành công")
                    self.dismiss(animated: true, completion: nil)
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    
    func Webservice_GetAffiliateInfo(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getLichSuRutTienResponseModel = try jsonDecoder.decode(GetAffiliateInfoModel.self, from: jsonResponse!)
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    
}
