//
//  OrderHistoryVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON



class WithdrawalLapLenhRutTienVC: UIViewController {
    
    @IBOutlet weak var btn_ok: UIButton!
    
    @IBOutlet weak var UILabelSoTienToiDa: UILabel!
    @IBOutlet weak var UITextFieldSoTien: UITextField!
    var Note = String()
    var userAffiliateInfoModel:UserAffiliateInfoModel=UserAffiliateInfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
    }
    
    
    @IBAction func btnTap_Ok(_ sender: UIButton) {
        let amount=String(self.UITextFieldSoTien.text!)
        if(UITextFieldSoTien.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            UITextFieldSoTien.text="";
            UITextFieldSoTien.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập số Số tiền", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        if(!amount.isNumber){
            UITextFieldSoTien.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập các số không bao gồm chữ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        if((amount as NSString).floatValue < 200000){
            
            UITextFieldSoTien.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập số Số tiền lớn hơn 200 000 ngàn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        
        let allowWithdrawal=self.userAffiliateInfoModel.total-self.userAffiliateInfoModel.total_processing;
        
        if((amount as NSString).floatValue > allowWithdrawal){
            
            UITextFieldSoTien.becomeFirstResponder()
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập số Số tiền không lớn hơn \(allowWithdrawal)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Bạn có chắc chắn muốn lập lệnh này không ?".localiz(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localiz(), style: .default) { (action) in
            let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
            
            let params: NSDictionary = [
                "user_id":user_id,
                "amount": amount
            ]
            let url_send_withdrawal_now = API_URL + "/api_task/withdrawals.send_withdrawal_now"
            self.Webservice_PostLapLenhRutTien(url: url_send_withdrawal_now, params:params)
            
            
        }
        let noAction = UIAlertAction(title: "No".localiz(), style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC,animated: true,completion: nil)
        
        
        
        
        
    }
    
    @IBAction func btnTap_dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}



//MARK: WithdrawalList
extension WithdrawalLapLenhRutTienVC {
    
    
    
    
    func Webservice_PostLapLenhRutTien(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let postLapLenhRutTienModel = try jsonDecoder.decode(PostLapLenhRutTienModel.self, from: jsonResponse!)
                    if(postLapLenhRutTienModel.result=="success"){
                        self.dismiss(animated: true, completion: nil)
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Bạn đã lập lệnh thành công, chúng tôi sẽ xem xét và sử lý lệnh này")
                    }
                    
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
                    self.userAffiliateInfoModel=getLichSuRutTienResponseModel.userAffiliateInfoModel
                    self.UILabelSoTienToiDa.text=String(self.userAffiliateInfoModel.total-self.userAffiliateInfoModel.total_processing)
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    
}
