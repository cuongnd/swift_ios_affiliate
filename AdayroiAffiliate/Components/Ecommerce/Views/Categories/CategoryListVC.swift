 //
//  OrderHistoryVC.swift
//  AdayroiAffiliate
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import AnyFormatKit

 class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var UIImageViewCategoryImage: UIImageView!
    
    @IBOutlet weak var UILabelCategoryName: UILabel!
    
 }

class CategoryListVC: UIViewController {
   
    var list_category:[CategoryModel]=[CategoryModel]()
    @IBOutlet weak var UICollectionViewCategories: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
         let urlStringGetListCategory = API_URL + "/api/categories"
         self.Webservice_getListCategory(url: urlStringGetListCategory, params: [:])
         
        
         
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


//MARK: CategoryListVC
extension CategoryListVC {
    
    
    func Webservice_getListCategory(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getApiResponseCategoryModel = try jsonDecoder.decode(GetApiResponseCategoryModel.self, from: jsonResponse!)
                    self.list_category=getApiResponseCategoryModel.list_category
                    self.UICollectionViewCategories.delegate = self
                    self.UICollectionViewCategories.dataSource = self
                    self.UICollectionViewCategories.reloadData()
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
   
    
}
 extension CategoryListVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return list_category.count
         
     }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = self.UICollectionViewCategories.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
           //cornerRadius(viewName: cell.img_categories, radius: 6.0)
           let categoryModel = self.list_category[indexPath.item]
        print("categoryModel \(categoryModel)")
        cell.UILabelCategoryName.text = categoryModel.name
        let categoryImage = categoryModel.default_photo
        cell.UIImageViewCategoryImage.sd_setImage(with: URL(string: categoryImage.img_path), placeholderImage: UIImage(named: "placeholder_image"))
         
           
           return cell
         
     }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
         
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width:(UIScreen.main.bounds.width) / 2, height: 250)
         
         
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let storyBoardProduct = UIStoryboard(name: "Products", bundle: nil)
         let categoryItem = self.list_category[indexPath.row]
         let searchVC = storyBoardProduct.instantiateViewController(identifier: "SearchVC") as! SearchVC
         searchVC.cat_id = categoryItem._id
         self.navigationController?.pushViewController(searchVC, animated: true)
  
         
     }
     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         
     }
     
 }
