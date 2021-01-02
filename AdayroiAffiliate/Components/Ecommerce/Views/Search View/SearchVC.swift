//
//  SearchVC.swift
//  AdayroiAffiliate
//
//  Created by iMac on 25/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchProductCell: UICollectionViewCell {
    @IBOutlet weak var img_search_product: UIImageView!
    @IBOutlet weak var lbl_SearchProductName: UILabel!
    @IBOutlet weak var lbl_SearchProductPercent: UILabel!
    
    @IBOutlet weak var UIImageViewShared: UIImageView!
    @IBOutlet weak var UILabelCommistion: UILabel!
    @IBOutlet weak var lbl_SearchProductOriginalPrice: UILabel!
    @IBOutlet weak var lbl_SearchProductUnitPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

class SearchVC: UIViewController {
    @IBOutlet weak var Collectioview_SearchList: UICollectionView!
    var pageIndex = 1
    var cat_id = ""
    var sub_cat_id = ""
    var lastIndex = 0
    @IBOutlet weak var lbl_titleLabel: UILabel!
    var list_product:[ProductModel] = [ProductModel]()
    var searchTxt = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_titleLabel.text = "Search".localiz()
        if(!self.cat_id.isEmpty){
            let urlString = API_URL + "/api/products?cat_id="+self.cat_id+"&sub_cat_id=\(sub_cat_id)&user_id="+String(UserDefaultManager.getStringFromUserDefaults(key: UD_userId));
            var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let params: NSDictionary = [:]
            self.Webservice_getSearch(url: urlString1!, params:params)
        }
    }
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func textTap_Search(_ sender: UITextField) {
        self.searchTxt = sender.text!
        print(searchTxt)
        if searchTxt == ""
        {
            self.list_product.removeAll()
            self.Collectioview_SearchList.reloadData()
        }
        else{
            let urlString = API_URL + "/api/products?cat_id=\(self.cat_id)&keyword="+String(searchTxt)+"&user_id="+String(UserDefaultManager.getStringFromUserDefaults(key: UD_userId));
            var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let params: NSDictionary = [:]
            self.Webservice_getSearch(url: urlString1!, params:params)
        }
    }
}
extension SearchVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.Collectioview_SearchList.bounds.size.width, height: self.Collectioview_SearchList.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        //messageLabel.font = UIFont(name: "POPPINS-REGULAR", size: 15)!
        messageLabel.sizeToFit()
        self.Collectioview_SearchList.backgroundView = messageLabel;
        if self.list_product.count == 0 {
            messageLabel.text = "NO DATA FOUND".localiz()
        }
        else {
            messageLabel.text = ""
        }
        return list_product.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.Collectioview_SearchList.dequeueReusableCell(withReuseIdentifier: "SearchProductCell", for: indexPath) as! SearchProductCell
        //cornerRadius(viewName: cell.img_categories, radius: 6.0)
        let productItem = self.list_product[indexPath.item]
        cell.lbl_SearchProductName.text = productItem.name
        cell.lbl_SearchProductOriginalPrice.text=LibraryUtilitiesUtility.format_currency(amount: UInt64(productItem.original_price), decimalCount: 0)
        cell.lbl_SearchProductUnitPrice.attributedText=LibraryUtilitiesUtility.format_currency(amount: UInt64(productItem.unit_price), decimalCount: 0).strikeThrough()
        cell.lbl_SearchProductPercent.text=String(productItem.discount_percent)+"%"
        let commistionValue=(productItem.commistion*productItem.unit_price)/100
        let commistionValue1=LibraryUtilitiesUtility.format_currency(amount: UInt64(commistionValue), decimalCount: 0)
        cell.UILabelCommistion.text="Hoa hồng:\(String(productItem.commistion))%(\(commistionValue1))"
        cell.img_search_product.sd_setImage(with: URL(string: productItem.default_photo.img_path), placeholderImage: UIImage(named: "placeholder_image"))
        
        cell.UIImageViewShared.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnTap_ShareProduct))
        cell.UIImageViewShared.isUserInteractionEnabled = true
        cell.UIImageViewShared.addGestureRecognizer(tap)
        
        
        
        return cell
        
    }
    
    
    
    @objc func btnTap_ShareProduct(sender: UITapGestureRecognizer)
    {
         let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let productItem=self.list_product[sender.view!.tag];
        let link_product_detail:String = "https://adayroi.online/landingpage/\(productItem._id)/\(user_id)/default/\(productItem.alias).html";
        let sharelinktext = "https://vantinviet1.page.link/?link=\(link_product_detail)&apn=vantinviet.banhangonline88&st=\(productItem.name)&sd=\(productItem.name)&utm_source=app_affiliate&product_id=\(productItem._id)&user_affiliate_id=\(user_id)&si=\(productItem.default_photo.img_path)&ibi=com.vantinviet.banhangonlineapp"
        
        
        
        let textShare = [ sharelinktext ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30.0) / 2, height: 275)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productItem = self.list_product[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
        //vc.itemsId = data["id"]!
        vc.itemsId = productItem._id
        vc.SubCategoryId = productItem.sub_cat_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.list_product.count - 1 {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                
                let urlString = API_URL + "/api/products?cat_id=\(self.cat_id)&keyword="+String(searchTxt)+"&limit=30&start="+String(self.pageIndex)+"&user_id"+String(UserDefaultManager.getStringFromUserDefaults(key: UD_userId));
                let params: NSDictionary = [:]
                var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                self.Webservice_getSearch(url: urlString1!, params:params)
            }
        }
    }
    
}
extension SearchVC
{
    func Webservice_getSearch(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getApiResponseProductsModel = try jsonDecoder.decode(GetApiResponseProductsModel.self, from: jsonResponse!)
                    self.list_product=getApiResponseProductsModel.list_product
                    self.Collectioview_SearchList.delegate = self
                    self.Collectioview_SearchList.dataSource = self
                    self.Collectioview_SearchList.reloadData()
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
    }
    
}
