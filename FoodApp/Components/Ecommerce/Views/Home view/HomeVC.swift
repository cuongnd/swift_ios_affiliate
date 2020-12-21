//
//  HomeVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 04/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import LanguageManager_iOS
import SlideMenuControllerSwift
import CoreLocation
import MapKit



class HomeCategoryCell: UICollectionViewCell {
    @IBOutlet weak var img_category: UIImageView!
    @IBOutlet weak var lbl_CategoryName: UILabel!
  

}

class HomeVC: UIViewController {
   
    
    
    @IBOutlet weak var Collectioview_lastProductList: UICollectionView!
    
    @IBOutlet weak var Collectioview_HomeHotCategoryList: UICollectionView!
    @IBOutlet weak var Collectioview_HomeHotProductList: UICollectionView!
    @IBOutlet weak var Collectioview_HomeDiscountProductList: UICollectionView!
    @IBOutlet weak var Collectioview_HomeCategoryList: UICollectionView!
    @IBOutlet weak var Collectioview_HomeFeatureProductList: UICollectionView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    var lastProductArray = [JSON]()
    var homeHotCategoryArray = [JSON]()
    var homeHotProductArray = [JSON]()
    var homeDiscountProductArray = [JSON]()
    var homeCategoryArray = [JSON]()
    var homeFeatureProductArray = [JSON]()
    var pageIndex = 1
    var lastIndex = 0
    var SelectedCategoryId = String()
    var selectedindex = 0
    var latitued = String()
    var longitude = String()
    
    @IBOutlet weak var HomeTitleFeatureProducts: HomeTitle!
    @IBOutlet weak var HomeTtitleCategories: HomeTitle!
    @IBOutlet weak var HomeTtitleDiscountProducts: HomeTitle!
    @IBOutlet weak var HomeTtitleHotProducts: HomeTitle!
    @IBOutlet weak var HomeTitleHotCategories: HomeTitle!
    @IBOutlet weak var HomeTtitleNewProducts: HomeTitle!
    @IBOutlet weak var homeHeader: HomeHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        let nibCell = UINib(nibName: "HomeFeatureProductCell", bundle: nil)
        Collectioview_HomeFeatureProductList.register(nibCell, forCellWithReuseIdentifier: "HomeFeatureProductCell")
       
        
        Collectioview_HomeHotCategoryList.register(UINib(nibName: "HomeHotCategoryCell", bundle: nil), forCellWithReuseIdentifier: "HomeHotCategoryCell")
        Collectioview_lastProductList.register(UINib(nibName: "HomeLastProductCell", bundle: nil), forCellWithReuseIdentifier: "HomeLastProductCell")
        Collectioview_HomeHotProductList.register(UINib(nibName: "HomeHotProductCell", bundle: nil), forCellWithReuseIdentifier: "HomeHotProductCell")
        Collectioview_HomeDiscountProductList.register(UINib(nibName: "HomeDiscountProductCell", bundle: nil), forCellWithReuseIdentifier: "HomeDiscountProductCell")
       
        let urlStringGetMainShopInfo = API_URL + "/api/ios/get_shop_info"
        self.Webservice_getMainShopInfo(url: urlStringGetMainShopInfo, params: [:])
        
       
        

   }
    
    @IBAction func GoToSearch(_ sender: UIButton) {
        let searchVC = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "SearchVC") as! SearchVC
       self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func ShowMenu(_ sender: UIButton) {
        print("hello ShowMenu")
        if UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "en" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "N/A"
        {
            self.slideMenuController()?.openLeft()
        }
        else {
            self.slideMenuController()?.openRight()
        }
    }
    
    @IBAction func GoToCart(_ sender: UIButton) {
        let addtoCartVC = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(identifier: "AddtoCartVC") as! AddtoCartVC
        self.navigationController?.pushViewController(addtoCartVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    
}
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Collectioview_lastProductList{
            return lastProductArray.count
        }else if collectionView == self.Collectioview_HomeHotCategoryList{
            return homeHotCategoryArray.count
        }else if collectionView == self.Collectioview_HomeHotProductList{
            return homeHotProductArray.count
        }else if collectionView == self.Collectioview_HomeDiscountProductList{
            return homeDiscountProductArray.count
        }else if collectionView == self.Collectioview_HomeCategoryList{
            return homeCategoryArray.count
        }else if collectionView == self.Collectioview_HomeFeatureProductList{
            return homeFeatureProductArray.count
        }else{
            return 0
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.Collectioview_lastProductList{
            let cell = self.Collectioview_lastProductList.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCell", for: indexPath) as! HomeLastProductCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.lastProductArray[indexPath.item]
            cell.lbl_ProductName.text = data["name"].stringValue
            let str_original_price=data["original_price"].stringValue+" đ";
            cell.lbl_LastProductOriginalPrice.attributedText = str_original_price.strikeThrough()
            cell.lbl_LastProductUnitPrice.text = data["unit_price"].stringValue+" đ"
            cell.lbl_LastProductPercent.text = data["discount_percent"].stringValue+"%"
            let productImage = data["default_photo"].dictionaryValue
            cell.img_product.sd_setImage(with: URL(string: productImage["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
          
            
            return cell
        }else if collectionView == self.Collectioview_HomeHotCategoryList{
            let cell = self.Collectioview_HomeHotCategoryList.dequeueReusableCell(withReuseIdentifier: "HomeHotCategoryCell", for: indexPath) as! HomeHotCategoryCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.homeHotCategoryArray[indexPath.item]
            cell.lbl_HotCategoryName.text = data["name"].stringValue
            let categoryImage = data["default_photo"].dictionaryValue
            cell.img_hot_category.sd_setImage(with: URL(string: categoryImage["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
           
            return cell
        }else if collectionView == self.Collectioview_HomeHotProductList{
            let cell = self.Collectioview_HomeHotProductList.dequeueReusableCell(withReuseIdentifier: "HomeHotProductCell", for: indexPath) as! HomeHotProductCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.homeHotProductArray[indexPath.item]
            cell.lbl_HotProductName.text = data["name"].stringValue
            let str_original_price=data["original_price"].stringValue+" đ";
            cell.lbl_HotProductOriginalPrice.attributedText = str_original_price.strikeThrough()
            cell.lbl_HotProductUnitPrice.text = data["unit_price"].stringValue+" đ"
            cell.lbl_HotProductPercent.text = data["discount_percent"].stringValue+"%"
            let product_Image = data["default_photo"].dictionaryValue
            cell.img_hot_product.sd_setImage(with: URL(string: product_Image["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
           
            return cell
        }else if collectionView == self.Collectioview_HomeDiscountProductList{
            let cell = self.Collectioview_HomeDiscountProductList.dequeueReusableCell(withReuseIdentifier: "HomeDiscountProductCell", for: indexPath) as! HomeDiscountProductCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.homeDiscountProductArray[indexPath.item]
            cell.lbl_DiscountProductName.text = data["name"].stringValue
            let str_original_price=data["original_price"].stringValue+" đ";
            cell.lbl_DiscountProductOriginalPrice.attributedText = str_original_price.strikeThrough()
            cell.lbl_DiscountProductUnitPrice.text = data["unit_price"].stringValue+" đ"
            cell.lbl_DiscountProductPercent.text = data["discount_percent"].stringValue+"%"
            let product_Image = data["default_photo"].dictionaryValue
            
            cell.img_discount_product.sd_setImage(with: URL(string: product_Image["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
          
            return cell
        }else if collectionView == self.Collectioview_HomeCategoryList{
            let cell = self.Collectioview_HomeCategoryList.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as! HomeCategoryCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.homeCategoryArray[indexPath.item]
            cell.lbl_CategoryName.text = data["name"].stringValue
            let category_Image = data["default_photo"].dictionaryValue
            cell.img_category.sd_setImage(with: URL(string: category_Image["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
            // corner radius
           
            return cell
        }else if collectionView == self.Collectioview_HomeFeatureProductList{
            let cell = self.Collectioview_HomeFeatureProductList.dequeueReusableCell(withReuseIdentifier: "HomeFeatureProductCell", for: indexPath) as! HomeFeatureProductCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.homeFeatureProductArray[indexPath.item]
            //cell.img.image = UIImage(named: "img_product")
            cell.lbName.text = data["name"].stringValue
            let str_original_price=data["original_price"].stringValue+" đ";
            cell.lbl_FeatureProductOriginalPrice.attributedText = str_original_price.strikeThrough()
            cell.lbl_FeatureProductUnitPrice.text = data["unit_price"].stringValue+" đ"
            cell.ProductDiscountPercent.text = data["discount_percent"].stringValue+"%"
            
            let product_Image = data["default_photo"].dictionaryValue
            cell.img.sd_setImage(with: URL(string: product_Image["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
            
            //cell.lbDesc.text = "sdfsdfdssdfdfds"
            
            return cell
            
            
        }else{
            let cell = self.Collectioview_lastProductList.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCell", for: indexPath) as! HomeLastProductCell
            //cornerRadius(viewName: cell.img_categories, radius: 6.0)
            let data = self.lastProductArray[indexPath.item]
            cell.lbl_ProductName.text = data["name"].stringValue
            
            let str_original_price=data["original_price"].stringValue+" đ";
            cell.lbl_LastProductOriginalPrice.attributedText = str_original_price.strikeThrough()
            
            cell.lbl_LastProductUnitPrice.text = data["unit_price"].stringValue+" đ"
            cell.lbl_LastProductPercent.text = data["discount_percent"].stringValue+"%"
            
            let productImage = data["default_photo"].dictionaryValue
            cell.img_product.sd_setImage(with: URL(string: productImage["img_path"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
            
            return cell
        }
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.Collectioview_lastProductList{
            return 2
        }else if collectionView == self.Collectioview_HomeHotCategoryList{
            return 2
        }else if collectionView == self.Collectioview_HomeHotProductList{
            return 1
        }else if collectionView == self.Collectioview_HomeDiscountProductList{
            return 2
        }else if collectionView == self.Collectioview_HomeCategoryList{
            return 2
        }else if collectionView == self.Collectioview_HomeFeatureProductList{
            return 2
        }else{
            return 2
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.Collectioview_lastProductList{
            return CGSize(width:(UIScreen.main.bounds.width) / 2, height: 250)
        }else if collectionView == self.Collectioview_HomeHotCategoryList{
            return CGSize(width:(UIScreen.main.bounds.width) / 3, height: 150)
        }else if collectionView == self.Collectioview_HomeHotProductList{
            return CGSize(width:(UIScreen.main.bounds.width) / 2, height: 250)
        }else if collectionView == self.Collectioview_HomeDiscountProductList{
            return CGSize(width:(UIScreen.main.bounds.width) / 2, height: 250)
        }else if collectionView == self.Collectioview_HomeCategoryList{
            return CGSize(width:(UIScreen.main.bounds.width) / 3, height: 150)
        }else if collectionView == self.Collectioview_HomeFeatureProductList{
            return CGSize(width:(UIScreen.main.bounds.width) / 1, height: 200)
        }else{
            return CGSize(width:(UIScreen.main.bounds.width) / 2, height: 120)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.Collectioview_lastProductList{
            let storyBoardProduct = UIStoryboard(name: "Products", bundle: nil)
            let data = self.lastProductArray[indexPath.row]
            let vc = storyBoardProduct.instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.itemsId = data["_id"].stringValue
            vc.SubCategoryId = data["sub_cat_id"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == self.Collectioview_HomeHotCategoryList{
            let data = self.homeHotCategoryArray[indexPath.row]
            let searchVC = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "SearchVC") as! SearchVC
            searchVC.cat_id=data["_id"].stringValue;
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else if collectionView == self.Collectioview_HomeHotProductList{
            let data = self.homeHotProductArray[indexPath.row]
            let vc = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.itemsId = data["_id"].stringValue
            vc.SubCategoryId = data["sub_cat_id"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == self.Collectioview_HomeDiscountProductList{
            let data = self.homeDiscountProductArray[indexPath.row]
            let vc = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.itemsId = data["_id"].stringValue
            vc.SubCategoryId = data["sub_cat_id"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == self.Collectioview_HomeCategoryList{
            let data = self.homeCategoryArray[indexPath.row]
            let searchVC = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "SearchVC") as! SearchVC
            searchVC.cat_id=data["_id"].stringValue;
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else if collectionView == self.Collectioview_HomeFeatureProductList{
            let data = self.homeFeatureProductArray[indexPath.row]
            let vc = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.itemsId = data["_id"].stringValue
            vc.SubCategoryId = data["sub_cat_id"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeVC
{
    func Webservice_getMainShopInfo(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                     let mainShopInfo = jsonResponse!["data"].dictionaryValue
                     UserDefaultManager.setStringToUserDefaults(value:mainShopInfo["currency"]!.stringValue, key: UD_currency)
                    
                     let urlString = API_URL + "/api/products?order_by=added_date"
                       self.Webservice_getHomeLastProducts(url: urlString, params: [:])
                       let urlStringHomeCategories = API_URL + "/api/categories"
                       self.Webservice_getHomeHotCategories(url: urlStringHomeCategories, params: [:])
                       let urlStringHomeHotProduct = API_URL + "/api/products?order_by=touch_count"
                       self.Webservice_getHomeHotProducts(url: urlStringHomeHotProduct, params: [:])
                       let urlStringHomeDiscountProduct = API_URL + "/api/products?is_discount=1"
                       self.Webservice_getHomeDiscountProducts(url: urlStringHomeDiscountProduct, params: [:])
                       let urlStringHomeCategory = API_URL + "/api/categories"
                       self.Webservice_getHomeCategories(url: urlStringHomeCategory, params: [:])
                       let urlStringHomeFeatureProducts = API_URL + "/api/products?is_featured=1"
                       self.Webservice_getHomeFeatureProducts(url: urlStringHomeFeatureProducts, params: [:])
                        
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_getHomeLastProducts(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let homeLastProductData = jsonResponse!["data"].arrayValue
                    self.lastProductArray = homeLastProductData
                    self.Collectioview_lastProductList.delegate = self
                    self.Collectioview_lastProductList.dataSource = self
                    self.Collectioview_lastProductList.reloadData()
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_getHomeHotCategories(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let homeCategoryData = jsonResponse!["data"].arrayValue
                    self.homeHotCategoryArray = homeCategoryData
                    self.Collectioview_HomeHotCategoryList.delegate = self
                    self.Collectioview_HomeHotCategoryList.dataSource = self
                    self.Collectioview_HomeHotCategoryList.reloadData()
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_getHomeHotProducts(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let homeHotProductsData = jsonResponse!["data"].arrayValue
                    self.homeHotProductArray = homeHotProductsData
                    self.Collectioview_HomeHotProductList.delegate = self
                    self.Collectioview_HomeHotProductList.dataSource = self
                    self.Collectioview_HomeHotProductList.reloadData()
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_getHomeDiscountProducts(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let homeDiscountProductsData = jsonResponse!["data"].arrayValue
                    self.homeDiscountProductArray = homeDiscountProductsData
                    self.Collectioview_HomeDiscountProductList.delegate = self
                    self.Collectioview_HomeDiscountProductList.dataSource = self
                    self.Collectioview_HomeDiscountProductList.reloadData()
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_getHomeCategories(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let homeCategoriesData = jsonResponse!["data"].arrayValue
                    self.homeCategoryArray = homeCategoriesData
                    self.Collectioview_HomeCategoryList.delegate = self
                    self.Collectioview_HomeCategoryList.dataSource = self
                    self.Collectioview_HomeCategoryList.reloadData()
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    func Webservice_getHomeFeatureProducts(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let homeFeatureProductsData = jsonResponse!["data"].arrayValue
                    self.homeFeatureProductArray = homeFeatureProductsData
                    self.Collectioview_HomeFeatureProductList.delegate = self
                    self.Collectioview_HomeFeatureProductList.dataSource = self
                    self.Collectioview_HomeFeatureProductList.reloadData()
                }
                    
                    
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
