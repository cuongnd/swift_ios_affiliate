//
//  SideMenuVC.swift
//  WallPaperApp
//
//  Created by Mitesh's MAC on 23/12/19.
//  Copyright © 2019 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
struct MenuModel {
    let title: String
    let icon: String
    let viewController:UINavigationController
    let is_logout:Bool
    init(title:String,icon:String,viewController:UINavigationController,is_logout:Bool) {
        self.title = title
        self.icon = icon
        self.is_logout = is_logout
        self.viewController=viewController
        
    }
}
class MenuTableCell: UITableViewCell {
    @IBOutlet weak var lbl_menu: UILabel!
    @IBOutlet weak var img_menu: UIImageView!
}

class SideMenuVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tbl_menu: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    //MARK: Variables
   
    var list_item_menu:[MenuModel] = [MenuModel]()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        var viewController=UINavigationController(rootViewController: homeVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Trang chủ", icon: "ic_Home",viewController: viewController,is_logout: false))
        
        
        let myProductListVC = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC
        viewController = UINavigationController(rootViewController: myProductListVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Chia sẻ sản phẩm", icon: "ic_Home",viewController: viewController,is_logout: false))
        
        
        let ordersVC = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
        viewController = UINavigationController(rootViewController: ordersVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Xem các đơn hàng", icon: "ic_OrderHistory",viewController: viewController,is_logout: false))
        
        
        let blogVC = UIStoryboard(name: "Blogs", bundle: nil).instantiateViewController(withIdentifier: "BlogsVC") as! BlogsVC
        viewController = UINavigationController(rootViewController: blogVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Hướng dẫn", icon: "ic_OrderHistory",viewController: viewController,is_logout: false))
               
        
        
        let withdrawalListVC = UIStoryboard(name: "Withdrawal", bundle: nil).instantiateViewController(withIdentifier: "WithdrawalListVC") as! WithdrawalListVC
        viewController = UINavigationController(rootViewController: withdrawalListVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Rút tiền", icon: "ic_Home",viewController: viewController,is_logout: false))
        
        
        
        let settingsVC = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        viewController = UINavigationController(rootViewController: settingsVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Cài đặt", icon: "ic_settings",viewController: viewController,is_logout: false))
        
       
        let loginVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        viewController = UINavigationController(rootViewController: loginVC)
        viewController.setNavigationBarHidden(true, animated: true)
        self.list_item_menu.append(MenuModel(title: "Đăng xuất", icon: "ic_logout",viewController: viewController,is_logout: true))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaultManager.getStringFromUserDefaults(key: UD_isSkip) != "1"
        {
            
            let urlString = API_URL + "/api/users/"+String(UserDefaults.standard.value(forKey: UD_userId) as! String)
            let params: NSDictionary = [:]
            self.Webservice_GetProfile(url: urlString, params: params)
        }
    }
}

//MARK: Tableview methods
extension SideMenuVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.list_item_menu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell") as! MenuTableCell
        let menuModel:MenuModel=self.list_item_menu[indexPath.row]
        cell.lbl_menu.text = menuModel.title
        cell.img_menu.image = UIImage.init(named: menuModel.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuModel:MenuModel=self.list_item_menu[indexPath.row]
        if(menuModel.is_logout){
             UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
        }
        self.slideMenuController()?.changeMainViewController(menuModel.viewController, close: true)
    }
}
//MARK: Webservices
extension SideMenuVC {
    func Webservice_GetProfile(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: "", messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let responseData = jsonResponse!["data"].dictionaryValue
                    print(responseData)
                    self.imgProfile.sd_setImage(with: URL(string: responseData["profile_image"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
                    self.lblUsername.text = responseData["name"]?.stringValue
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
}
