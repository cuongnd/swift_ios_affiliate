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
import ETBinding
import TagListView
import SlideMenuControllerSwift

class CartCell: UITableViewCell {
    
    @IBOutlet weak var lbl_ProductName: UILabel!
    @IBOutlet weak var img_Product: UIImageView!
    
    @IBOutlet weak var btn_Notes: UIButton!
    @IBOutlet weak var btn_Addonse: UIButton!
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var btn_Minse: UIButton!
    @IBOutlet weak var btn_Pluse: UIButton!
    @IBOutlet weak var UICollectionViewAttributes: UICollectionView!
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var UILabelColorName: UILabel!
}
class attributeCell: UICollectionViewCell {
    @IBOutlet weak var UILabelKey: UILabel!
    @IBOutlet weak var UILabelValue: UILabel!
}
class AddtoCartVC: UIViewController {
    
    @IBOutlet weak var btn_Checkout: UIButton!
    @IBOutlet weak var lbl_TitleLabel: UILabel!
    
    @IBOutlet weak var UILabelTotalProduct: UILabel!
    @IBOutlet weak var UILabelTotal: UILabel!
    @IBOutlet weak var TableView_CartList: UITableView!
    var cartDetailsarray = [[String:Any]]()
    var getCartData = [JSON]()
    var liveDataCart: LiveData<[[String:Any]]> = LiveData(data: [[:]])
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_TitleLabel.text = "Cart".localiz()
        
        self.btn_Checkout.setTitle("Checkout".localiz(), for: .normal)
        cornerRadius(viewName:btn_Checkout, radius: 8.0)
        //let urlString = API_URL + "getcart"
        //let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        //self.Webservice_GetCartDetails(url: urlString, params:params)
        self.showCart()
        let observer: Observer<[[String:Any]]> = Observer(update: { data in
            print("hello \(data)")
        })
        // … and later
        
        liveDataCart.observeForever(observer: observer)
        
        
        
    }
    
    @IBAction func btnTap_Checkout(_ sender: UIButton) {
        if UserDefaultManager.getStringFromUserDefaults(key: UD_isSkip) == "1"
        {
            let storyBoard = UIStoryboard(name: "User", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            UIApplication.shared.windows[0].rootViewController = nav
        }
        else{
            let storyBoard = UIStoryboard(name: "Checkout", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "ADRFrontEndViewCheckoutVC") as! ADRFrontEndViewCheckoutVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            UIApplication.shared.windows[0].rootViewController = nav
        }
        
        
        
        
    }
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_Home(_ sender: UIButton) {
        
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
}
extension AddtoCartVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.TableView_CartList.bounds.size.width, height: self.TableView_CartList.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        //               messageLabel.font = UIFont(name: "Gilroy-Medium", size: 17)!
        messageLabel.sizeToFit()
        self.TableView_CartList.backgroundView = messageLabel;
        if self.cartDetailsarray.count == 0 {
            messageLabel.text = "NO DATA FOUND".localiz()
            self.btn_Checkout.isHidden = true
        }
        else {
            messageLabel.text = ""
            self.btn_Checkout.isHidden = false
        }
        
        return self.cartDetailsarray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TableView_CartList.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        cornerRadius(viewName: cell.img_Product, radius: 6.0)
        cornerRadius(viewName: cell.btn_Addonse, radius:4.0)
        cornerRadius(viewName: cell.btn_Notes, radius:4.0)
        
        let data = self.cartDetailsarray[indexPath.row]
        cell.lbl_count.text! = (data["qty"]! as AnyObject).stringValue
        
        cell.lbl_Price.text! = "\(UserDefaultManager.getStringFromUserDefaults(key: UD_currency))\(data["price"]!)"
        if Int((data["qty"]! as AnyObject).stringValue)! <= 1
        {
            cell.btn_Minse.isEnabled = false
        }
        else{
            cell.btn_Minse.isEnabled = true
        }
        cell.lbl_ProductName.text! = data["item_name"]! as! String
        let imgUrl =  data["itemimage"]!
        print(data["price_update"]!)
        
        cell.img_Product.sd_setImage(with: URL(string: imgUrl as! String), placeholderImage: UIImage(named: "placeholder_image"))
        cell.btn_Minse.tag = indexPath.row
        cell.btn_Minse.addTarget(self, action: #selector(btnTapMines), for: .touchUpInside)
        cell.btn_Pluse.tag = indexPath.row
        cell.btn_Pluse.addTarget(self, action: #selector(btnTapPluse), for: .touchUpInside)
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(btnTapDelete), for: .touchUpInside)
        cell.btn_Addonse.tag = indexPath.row
        cell.btn_Addonse.addTarget(self, action: #selector(btnTapAddonse), for: .touchUpInside)
        cell.btn_Notes.tag = indexPath.row
        cell.btn_Notes.addTarget(self, action: #selector(btnTapNotes), for: .touchUpInside)
        /*
         let isaddonce = data["addons"]! as! [JSON]
         if isaddonce.count == 0
         {
         cell.btn_Addonse.isEnabled = false
         cell.btn_Addonse.backgroundColor = UIColor.lightGray
         }
         else{
         cell.btn_Addonse.isEnabled = true
         }
         */
        let item_notes = data["item_notes"] as! String
        
        if item_notes == ""
        {
            cell.btn_Notes.isEnabled = false
            cell.btn_Notes.backgroundColor = UIColor.lightGray
        }
        else
        {
            cell.btn_Notes.isEnabled = true
            
        }
        let itemimage:String = data["color_image"] as! String
        cell.UILabelColorName.text=data["color_value"] as! String
        cell.colorImage.sd_setImage(with: URL(string: itemimage), placeholderImage: UIImage(named: "placeholder_image"))
        let list_attribute_value=JSON(data["attributes"]!);
        cell.tagListView.textFont = UIFont.systemFont(ofSize: 14)
        cell.tagListView.alignment = .left // possible values are [.leading, .trailing, .left, .center, .right]
        for index in 0...list_attribute_value.count-1 {
            let attribute=list_attribute_value[index]
            cell.tagListView.addTag("\(attribute["name"].stringValue):\(attribute["value"].stringValue)")
        }
      return cell
    }
    
    @objc func btnTapMines(sender:UIButton)
    {
        let data = cartDetailsarray[sender.tag]
        let cart_id = data["id"]! as! Int64
        ADRFrontEndModelCartItem.shared.minesCartItem(cart_id: cart_id, mines: 1);
        self.showCart()
    }
    @objc func btnTapPluse(sender:UIButton)
    {
        let data = cartDetailsarray[sender.tag]
        let cart_id = data["id"]! as! Int64
        ADRFrontEndModelCartItem.shared.plusCartItem(cart_id: cart_id, plus: 1);
        self.showCart()
    }
    @objc func btnTapDelete(sender:UIButton)
    {
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Are you sure to remove this item from your cart list?".localiz(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localiz(), style: .default) { (action) in
            let data = self.cartDetailsarray[sender.tag]
            let urlString = API_URL + "deletecartitem"
            let params: NSDictionary = ["cart_id":data["id"]!]
            ADRFrontEndModelCartItem.shared.DeleteCartItem(id: data["id"]! as! Int64)
            self.showCart()
            
            //self.Webservice_DeleteCartItem(url: urlString, params:params)
        }
        let noAction = UIAlertAction(title: "No".localiz(), style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC,animated: true,completion: nil)
    }
    @objc func btnTapAddonse(sender:UIButton)
    {
        let data = cartDetailsarray[sender.tag]
        let addonceData = data["addons"]!
        print(addonceData)
        let vc = self.storyboard?.instantiateViewController(identifier: "AddonceListVC") as! AddonceListVC
        vc.SelectedAddons = addonceData as! [JSON]
        self.present(vc, animated: true, completion: nil)
    }
    @objc func btnTapNotes(sender:UIButton)
    {
        let data = cartDetailsarray[sender.tag]
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "NoteVC") as! NoteVC
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        VC.Note = data["item_notes"] as! String
        self.present(VC,animated: true,completion: nil)
        
    }
}

extension AddtoCartVC
{
    func showCart() -> Void{
        self.cartDetailsarray.removeAll(keepingCapacity: true)
        var totalProduct:Int64=0;
        var totalPrice:Int64=0;
        if let itemsCart:AnySequence<Row> = ADRFrontEndModelCartItems.getList(){
            
            
            for item in itemsCart {
                
                do{
                    var attributes = [[String:Any]]()
                    let cart_id=try item.get(Expression<Int64>("id"))
                    if let itemsAtributeCart:AnySequence<Row> = ADRFrontEndModelCartItems.getAttributeListByCartId(cart_id: cart_id as! Int64){
                        for item in itemsAtributeCart {
                            do{
                                
                                let a_obj = [
                                    "id":try item.get(Expression<Int64>("id")),
                                    "product_id":try item.get(Expression<String>("product_id")),
                                    "name":try item.get(Expression<String>("name")),
                                    "value":try item.get(Expression<String>("value")),
                                    "attribute_id":try item.get(Expression<String>("attribute_id")),
                                    "parent_attribute_id":try item.get(Expression<String>("parent_attribute_id")),
                                    ] as [String : Any]
                                print("a_obj: \(a_obj)")
                                attributes.append(a_obj)
                                
                            }catch{
                                let nsError=error as NSError
                                print("get value of column table Cart error. Error is \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }
                    let quality:Int64=try item.get(Expression<Int64>("quality"));
                    totalProduct=totalProduct+quality;
                    let unit_price:Int64=try item.get(Expression<Int64>("unit_price"))
                    totalPrice=unit_price*quality+totalPrice
                    let obj = [
                        "id":try item.get(Expression<Int64>("id")),
                        "product_id":try item.get(Expression<String>("product_id")),
                        "qty":try item.get(Expression<Int64>("quality")),
                        "price":try item.get(Expression<Int64>("unit_price")),
                        "price_update":try item.get(Expression<Int64>("unit_price")),
                        "item_name":try item.get(Expression<String>("name")),
                        "item_id":try item.get(Expression<String>("product_id")),
                        "itemimage":try item.get(Expression<String>("image")),
                        "color_id":try item.get(Expression<String>("color_id")),
                        "color_name":try item.get(Expression<String>("color_name")),
                        "color_value":try item.get(Expression<String>("color_value")),
                        "color_image":try item.get(Expression<String>("color_image")),
                        "addons":[:],
                        "item_notes":try item.get(Expression<String>("product_id")),
                        "attributes":attributes,
                        ] as [String : Any]
                    
                    
                    
                    
                    
                    
                    self.cartDetailsarray.append(obj)
                }catch{
                    let nsError=error as NSError
                    print("get value of column table Cart error. Error is \(nsError), \(nsError.userInfo)")
                }
                
                
            }
            self.liveDataCart.data=self.cartDetailsarray
        }
        
        
        print("total:\(totalProduct)")
        print("totalPrice:\(totalPrice)")
        //self.UILabelTotalProduct.delegate = self
        //self.UILabelTotal.delegate = self
        
        UILabelTotalProduct.text=String(totalProduct);
        UILabelTotal.text=String(totalPrice);
        
        
        self.TableView_CartList.delegate = self
        self.TableView_CartList.dataSource = self
        self.TableView_CartList.reloadData()
    }
    func Webservice_GetCartDetails(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["status"].stringValue
                if responseCode == "1" {
                    let responceData = jsonResponse!["data"].arrayValue
                    self.cartDetailsarray.removeAll()
                    for data in responceData
                    {
                        let itemsimage = data["itemimage"].dictionaryValue
                        print(itemsimage)
                        let ItemPrice = formatter.string(for: data["price"].stringValue.toDouble)
                        let obj = ["id":data["id"].stringValue,"qty":data["qty"].stringValue,"price":ItemPrice!,"price_update":data["price"].stringValue,"item_name":data["item_name"].stringValue,"item_id":data["item_id"].stringValue,"itemimage":itemsimage["image"]!.stringValue,"addons":data["addons"].arrayValue,"item_notes":data["item_notes"].stringValue] as [String : Any]
                        self.cartDetailsarray.append(obj)
                    }
                    self.TableView_CartList.delegate = self
                    self.TableView_CartList.dataSource = self
                    self.TableView_CartList.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_QtyUpdate(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["status"].stringValue
                if responseCode == "1" {
                    //                    let responceData = jsonResponse!["data"].arrayValue
                    let urlString = API_URL + "getcart"
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
                    self.Webservice_GetCartDetails(url: urlString, params:params)
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_DeleteCartItem(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["status"].stringValue
                if responseCode == "1" {
                    //                    let responceData = jsonResponse!["data"].arrayValue
                    let urlString = API_URL + "getcart"
                    let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
                    self.Webservice_GetCartDetails(url: urlString, params:params)
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_OpenClose(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["status"].stringValue
                if responseCode == "1" {
                    let vc = self.storyboard?.instantiateViewController(identifier: "OrderDetails") as! OrderDetails
                    self.navigationController?.pushViewController(vc, animated:true)
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
}
extension AddtoCartVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data=self.cartDetailsarray[collectionView.tag]
        let attributes=JSON(data["attributes"]!);
        return attributes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attributeCell", for: indexPath) as! attributeCell
        print("collectionView.tag \(collectionView.tag)")
        let data=self.cartDetailsarray[collectionView.tag]
        let attributes=JSON(data["attributes"]!);
        let attribute=attributes[indexPath.row];
        cell.UILabelKey.text=attribute["name"].stringValue;
        cell.UILabelValue.text=attribute["value"].stringValue;
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) / 3, height: 50.0)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}
