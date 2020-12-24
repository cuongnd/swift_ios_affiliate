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
    @IBOutlet weak var text_viewNote: UITextView!
    var Note = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.text_viewNote.text = Note
        
    }
    

    @IBAction func btnTap_Ok(_ sender: UIButton) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let url_send_withdrawal_now = API_URL + "/api_task/withdrawals.send_withdrawal_now?user_id=\(user_id)"
               self.Webservice_GetLapLenhRutTien(url: url_send_withdrawal_now, params:[:])
        
        
    }
    
    @IBAction func btnTap_dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    
}



//MARK: WithdrawalList
extension WithdrawalLapLenhRutTienVC {
    
    
   
    
    func Webservice_GetLapLenhRutTien(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getLichSuRutTienResponseModel = try jsonDecoder.decode(GetAffiliateInfoModel.self, from: jsonResponse!)
                        self.dismiss(animated: true, completion: nil)
                   
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
   
}
