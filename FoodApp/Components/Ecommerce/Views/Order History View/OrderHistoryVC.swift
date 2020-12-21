//
//  OrderHistoryVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lbl_OrderNoLabel: UILabel!
    @IBOutlet weak var lbl_QtyLabel: UILabel!
    @IBOutlet weak var lbl_orderStatusLabel: UILabel!
    
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_PaymentType: UILabel!
    @IBOutlet weak var lbl_OrderNumber: UILabel!
    @IBOutlet weak var lbl_itemPrice: UILabel!
    @IBOutlet weak var lbl_itemAddress: UILabel!
    @IBOutlet weak var lbl_itemQty: UILabel!
}


class OrderHistoryVC: UIViewController {
    @IBOutlet weak var Tableview_OrderHistory: UITableView!
    @IBOutlet weak var lbl_titleLabel: UILabel!
    var refreshControl = UIRefreshControl()
    var OrderHistoryData = [JSON]()
    var selected = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selected = ""
        self.Tableview_OrderHistory.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        self.lbl_titleLabel.text = "Order History".localiz()
    }
    @objc private func refreshData(_ sender: Any) {
        self.refreshControl.endRefreshing()
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
extension OrderHistoryVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.Tableview_OrderHistory.bounds.size.width, height: self.Tableview_OrderHistory.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        //messageLabel.font = UIFont(name: "POPPINS-REGULAR", size: 15)!
        messageLabel.sizeToFit()
        self.Tableview_OrderHistory.backgroundView = messageLabel;
        if self.OrderHistoryData.count == 0 {
            messageLabel.text = "NO ORDER HISTORY"
        }
        else {
            messageLabel.text = ""
        }
        return OrderHistoryData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        _ = self.OrderHistoryData[indexPath.row]
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.Tableview_OrderHistory.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryCell
        let data = self.OrderHistoryData[indexPath.row]
        cell.lbl_QtyLabel.text = "QTY :".localiz()
        cell.lbl_OrderNoLabel.text = "ORDER ID :".localiz()
        cell.lbl_orderStatusLabel.text = "STATUS :".localiz()
        cell.lbl_itemQty.text = data["qty"].stringValue
        cell.lbl_Date.text = data["date"].stringValue
        //let setdate = DateFormater.getBirthDateStringFromDateString(givenDate:data["created_date"].stringValue)
        //cell.lbl_Date.text = setdate
        _ = data["order_status_id"].stringValue
        
        cell.lbl_OrderNumber.text = data["order_number"].stringValue
        let ItemPrice = formatter.string(for: data["total"].stringValue.toDouble)
        cell.lbl_itemPrice.text = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(ItemPrice!)"
        cell.lbl_PaymentType.text =  data["payment_method_name"].stringValue
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.OrderHistoryData[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "OrderHistoryDetailsVC") as! OrderHistoryDetailsVC
        vc.OrderId = data["_id"].stringValue
        vc.status = data["status"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: Webservices
extension OrderHistoryVC {
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
                    self.Tableview_OrderHistory.delegate = self
                    self.Tableview_OrderHistory.dataSource = self
                    self.Tableview_OrderHistory.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
}
