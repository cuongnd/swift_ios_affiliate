//
//  SearchVC.swift
//  AdayroiAffiliate
//
//  Created by iMac on 25/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class BlogCell: UICollectionViewCell {
    
    @IBOutlet weak var UIImageViewBlogImage: UIImageView!
    
    @IBOutlet weak var UIImageViewSharingBlogItem: UIImageView!
    @IBOutlet weak var UILabelBlogTitle: UILabel!
}

class BlogsVC: UIViewController {
    @IBOutlet weak var Collectioview_SearchList: UICollectionView!
    var pageIndex = 1
    var cat_id = ""
    var sub_cat_id = ""
    var lastIndex = 0
    @IBOutlet weak var lbl_titleLabel: UILabel!
    var list_blog:[BlogModel] = [BlogModel]()
    
    var searchTxt = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = API_URL + "/api/blogs?limit=20&start=0";
        var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let params: NSDictionary = [:]
        self.Webservice_getBlogs(url: urlString1!, params:params)
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
    
    @IBAction func textTap_Search(_ sender: UITextField) {
        self.searchTxt = sender.text!
        print(searchTxt)
        if searchTxt == ""
        {
            self.list_blog.removeAll()
            self.Collectioview_SearchList.reloadData()
        }
        else{
            let urlString = API_URL + "/api/api/blogs?limit=20&start=0";
            var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let params: NSDictionary = [:]
            self.Webservice_getBlogs(url: urlString1!, params:params)
        }
    }
}
extension BlogsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.Collectioview_SearchList.bounds.size.width, height: self.Collectioview_SearchList.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        //messageLabel.font = UIFont(name: "POPPINS-REGULAR", size: 15)!
        messageLabel.sizeToFit()
        self.Collectioview_SearchList.backgroundView = messageLabel;
        if self.list_blog.count == 0 {
            messageLabel.text = "NO DATA FOUND".localiz()
        }
        else {
            messageLabel.text = ""
        }
        return list_blog.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.Collectioview_SearchList.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as! BlogCell
        //cornerRadius(viewName: cell.img_categories, radius: 6.0)
        let blogItem:BlogModel = self.list_blog[indexPath.item]
        if(blogItem.image_intro != nil){
            cell.UIImageViewBlogImage.sd_setImage(with: URL(string: blogItem.image_intro!.img_path), placeholderImage: UIImage(named: "placeholder_image"))
        }
        cell.UILabelBlogTitle.text=blogItem.title
        
        cell.UIImageViewSharingBlogItem.tag = indexPath.row
       let tap = UITapGestureRecognizer(target: self, action: #selector(btnTap_ShareBlog))
       cell.UIImageViewSharingBlogItem.isUserInteractionEnabled = true
       cell.UIImageViewSharingBlogItem.addGestureRecognizer(tap)
        
        //cell.lbl_titleLabel.text = blogItem.title
        /*
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
        
        */
        
        return cell
        
    }
    
    
    
    @objc func btnTap_ShareBlog(sender: UITapGestureRecognizer)
    {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let blogItem:BlogModel=self.list_blog[sender.view!.tag];
        let link_product_detail:String = "https://adayroi.online/landingpage/\(blogItem._id)/\(user_id)/default/\(blogItem.alias).html";
        let sharelinktext = "https://vantinviet1.page.link/?link=\(link_product_detail)&apn=vantinviet.banhangonline88&st=\(blogItem.title)&sd=\(blogItem.title)&utm_source=app_affiliate&product_id=\(blogItem._id)&user_affiliate_id=\(user_id)&si=\(blogItem.image_intro!.img_path)&ibi=com.vantinviet.banhangonlineapp"
        
        
        
        let textShare = [ sharelinktext ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 275)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let blogItem = self.list_blog[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "BlogDetailsVC") as! BlogDetailsVC
        //vc.itemsId = data["id"]!
        vc.blog_id = blogItem._id
        vc.sub_cat_id = blogItem.sub_cat_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.list_blog.count - 1 {
            if self.pageIndex != self.lastIndex {
                self.pageIndex = self.pageIndex + 1
                
                let urlString = API_URL + "/api/api/blogs?limit=20&start=0";
                var urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let params: NSDictionary = [:]
                self.Webservice_getBlogs(url: urlString1!, params:params)
            }
        }
    }
    
}
extension BlogsVC
{
    func Webservice_getBlogs(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getApiRespondeBlogsModel = try jsonDecoder.decode(GetApiRespondeBlogsModel.self, from: jsonResponse!)
                    self.list_blog=getApiRespondeBlogsModel.list_blog
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
