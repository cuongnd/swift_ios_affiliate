//
//  OrderHistoryVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Withdrawal: UITableViewCell {
    

}


class WithdrawalListVC: UIViewController {
    var OrderHistoryData = [JSON]()
    var selected = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selected = ""
        
    }
    @objc private func refreshData(_ sender: Any) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/orders/my_list_order/limit/30/start/0?user_id=\(user_id)"
        self.Webservice_GetHistory(url: urlString, params:[:])
    }
    override func viewWillAppear(_ animated: Bool) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/orders/my_list_order/limit/30/start/0?user_id=\(user_id)"
        self.Webservice_GetHistory(url: urlString, params:[:])
    }
    @IBAction func btnTap_Menu(_ sender: UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "en" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "N/A"
        {
            self.slideMenuController()?.openLeft()
        }
        else {
            self.slideMenuController()?.openRight()
        }
    }
}

//MARK: WithdrawalList
extension WithdrawalListVC {
    func Webservice_GetHistory(url:String, params:NSDictionary) -> Void {
        
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: "", messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let responseData = jsonResponse!["list_order"].arrayValue
                    self.OrderHistoryData = responseData
                    self.selected = ""
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
}
