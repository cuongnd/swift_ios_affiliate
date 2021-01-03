//
//  ProductDetailsVC.swift
//  AdayroiAffiliate
//
//  Created by Mitesh's MAC on 04/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import ImageSlideshow
import WebKit
import SwiftyJSON
import iOSDropDown
import SQLite
import ETBinding

class BlogDetailColorCell: UICollectionViewCell {
    
    
}


class RelatedBlogCell: UICollectionViewCell {
    
    
}
class BlogDetailsVC: UIViewController,UITextViewDelegate,WKUIDelegate, WKNavigationDelegate {
    
    
    
    @IBOutlet weak var UIImageViewShare: UIImageView!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var CollectionViewRelatedBlogs: UICollectionView!
    
    @IBOutlet weak var lblBlogTitle: UILabel!
    @IBOutlet weak var lbl_SubCategoriesName: UILabel!
    
    @IBOutlet weak var lbl_IngredientsLavel: UILabel!
    var blog_id = String()
    var sub_cat_id = String()
    var RelatedProductsData = [JSON]()
    var colorsData:[ColorModel]=[ColorModel]()
    var list_blog_related:[BlogModel] = [BlogModel]()
    var productImages = [SDWebImageSource]()
    
    var FinalTotal = Double()
    var itemsData=[String : JSON]();
    var blogItem:BlogModel=BlogModel();
    
    
    @IBOutlet weak var UIImageViewOpenBrowser: UIImageView!
    @IBOutlet weak var MainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var heightWebview: NSLayoutConstraint!
    @IBOutlet weak var DescriptionBlog: WKWebView!
    @IBOutlet weak var UIImageViewCopyLink: UIImageView!
    var objectMapperFrontendProduct:ObjectMapperFrontendProduct!
    var liveDataCart: LiveData<[[String:Any]]> = LiveData(data: [[:]])
    
    @IBOutlet weak var UIImageViewOpenBrowser2: UIImageView!
    
    @IBOutlet weak var UIImageViewSharing2: UIImageView!
    @IBOutlet weak var UIImageViewCopy2: UIImageView!
    
    @IBOutlet weak var UILabelOriginPrice: UILabel!
    @IBOutlet weak var UILabelUnitPrice: UILabel!
    
    @IBOutlet weak var UILabelCommistion2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_IngredientsLavel.text = "Ingredients".localiz()
        let urlString = API_URL + "/api/blogs/"+String(self.blog_id)
        let params: NSDictionary = [:]
        self.Webservice_getBlogDetail(url: urlString, params:params)
        
        
        self.DescriptionBlog.navigationDelegate = self
        let urlGetRelatedBlogs = API_URL + "/api/blogs/get_related_blog_trending/blog_id/\(String(self.blog_id))/sub_cat_id/\(self.sub_cat_id)"
        let paramsRelatedBlogs: NSDictionary = [:]
        self.Webservice_getRelatedBlogs(url: urlGetRelatedBlogs, params:paramsRelatedBlogs)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnTap_ShareProduct))
        self.UIImageViewShare.isUserInteractionEnabled = true
        self.UIImageViewShare.addGestureRecognizer(tap)
        
        self.UIImageViewSharing2.isUserInteractionEnabled = true
        self.UIImageViewSharing2.addGestureRecognizer(tap)
        
        
        
        let tapCopy = UITapGestureRecognizer(target: self, action: #selector(btnTap_copyLinkProduct))
        self.UIImageViewCopyLink.isUserInteractionEnabled = true
        self.UIImageViewCopyLink.addGestureRecognizer(tapCopy)
        
        
        self.UIImageViewCopy2.isUserInteractionEnabled = true
        self.UIImageViewCopy2.addGestureRecognizer(tapCopy)
        
        
        
        let tapOpenBrowser = UITapGestureRecognizer(target: self, action: #selector(btnTap_OpenBrowserLinkProduct))
        self.UIImageViewOpenBrowser.isUserInteractionEnabled = true
        self.UIImageViewOpenBrowser.addGestureRecognizer(tapOpenBrowser)
        
        self.UIImageViewOpenBrowser2.isUserInteractionEnabled = true
        self.UIImageViewOpenBrowser2.addGestureRecognizer(tapOpenBrowser)
        
        
        let tapOpenSubCategory = UITapGestureRecognizer(target: self, action: #selector(btnTap_OpenSubCategory))
        self.lbl_SubCategoriesName.isUserInteractionEnabled = true
        self.lbl_SubCategoriesName.addGestureRecognizer(tapOpenSubCategory)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let urlString = API_URL1 + "cartcount"
        let params: NSDictionary = ["user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId)]
        //self.Webservice_cartcount(url: urlString, params:params)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @objc func btnTap_OpenSubCategory(sender: UITapGestureRecognizer)
    {
        
        let storyBoardProduct = UIStoryboard(name: "Products", bundle: nil)
        let searchVC = storyBoardProduct.instantiateViewController(identifier: "SearchVC") as! SearchVC
        //searchVC.blog_id = self.blogItem._id
        //searchVC.sub_cat_id = self.productItem.sub_cat_id
        self.navigationController?.pushViewController(searchVC, animated: true)
        
        
    }
    
    @objc func btnTap_copyLinkProduct(sender: UITapGestureRecognizer)
    {
        
        print("Button tapped")
        
        
        
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        //let productItem=self.list_product[sender.view!.tag];
        let link_product_detail:String = "https://adayroi.online/landingpage/\(self.blogItem._id)/\(user_id)/default/\(self.blogItem.alias).html";
        
        /// let sharelinktext = "https://vantinviet1.page.link/?link=\(link_product_detail)&apn=vantinviet.banhangonline88&st=\(self.itemsData["name"]?.stringValue)&sd=\(self.productItem.name)&utm_source=app_affiliate&product_id=\(self.productItem._id)&user_affiliate_id=\(user_id)&si=\(self.productItem.default_photo.img_path)&ibi=com.vantinviet.banhangonlineapp"
        
        
        
        UIPasteboard.general.string = link_product_detail
        
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Link sản phẩm đã được sao chép")
        
        
    }
    
    @objc func btnTap_OpenBrowserLinkProduct(sender: UITapGestureRecognizer)
    {
        
        print("Button tapped")
        
        
        /*
         let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
         //let productItem=self.list_product[sender.view!.tag];
         let link_product_detail:String = "https://adayroi.online/landingpage/\(self.productItem._id)/\(user_id)/default/\(self.productItem.alias).html";
         
         let sharelinktext = "https://vantinviet1.page.link/?link=\(link_product_detail)&apn=vantinviet.banhangonline88&st=\(self.itemsData["name"]?.stringValue)&sd=\(self.productItem.name)&utm_source=app_affiliate&product_id=\(self.productItem._id)&user_affiliate_id=\(user_id)&si=\(self.productItem.default_photo.img_path)&ibi=com.vantinviet.banhangonlineapp"
         print("link_product_detail \(link_product_detail)")
         guard let url = URL(string: link_product_detail) else { return }
         UIApplication.shared.open(url)
         */
        
        
    }
    
    
    
    @objc func btnTap_ShareProduct(sender: UITapGestureRecognizer)
    {
        /*
         let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
         //let productItem=self.list_product[sender.view!.tag];
         let link_product_detail:String = "https://adayroi.online/landingpage/\(self.productItem._id)/\(user_id)/default/\(self.productItem.alias).html";
         
         let sharelinktext = "https://vantinviet1.page.link/?link=\(link_product_detail)&apn=vantinviet.banhangonline88&st=\(self.itemsData["name"]?.stringValue)&sd=\(self.productItem.name)&utm_source=app_affiliate&product_id=\(self.productItem._id)&user_affiliate_id=\(user_id)&si=\(self.productItem.default_photo.img_path)&ibi=com.vantinviet.banhangonlineapp"
         
         
         
         let textShare = [ sharelinktext ]
         let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = self.view
         self.present(activityViewController, animated: true, completion: nil)
         */
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Notes".localiz()
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.DescriptionBlog.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.DescriptionBlog.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("hello set height")
                    print(height!)
                    //self.DescriptionProduct.frame.size.height = 1
                    //self.DescriptionProduct.frame.size = self.DescriptionProduct.sizeThatFits(.zero)
                    //self.DescriptionProduct.scrollView.isScrollEnabled=false;
                    //myWebViewHeightConstraint.constant = self.DescriptionProduct.scrollView.contentSize.height
                    self.heightWebview?.constant = height as! CGFloat
                    print(height!)
                    self.MainViewHeight?.constant += height as! CGFloat
                    print(height!)
                    if((height as! Double)>10000){
                        //self.heightWebview?.constant = (height as! CGFloat)-10000
                        //self.MainViewHeight?.constant += (height as! CGFloat)-10000
                    }else{
                        //self.heightWebview?.constant = (height as! CGFloat)
                        //self.MainViewHeight?.constant += (height as! CGFloat)
                    }
                    // self.DescriptionProduct.frame = CGRect(x: 0, y: 0, width: self.DescriptionProduct.frame.width, height: self.DescriptionProduct.frame.height + 6000.0)
                    
                    //self.DescriptionProduct.frame.size.height = height as! CGFloat
                })
            }
            
        })
        
        
    }
    
}


extension BlogDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list_blog_related.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.CollectionViewRelatedBlogs.dequeueReusableCell(withReuseIdentifier: "RelatedBlogCell", for: indexPath) as! RelatedBlogCell
        let data = self.list_blog_related[indexPath.item]
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: 260.0)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
         let data = self.RelatedProductsData[indexPath.row]
         itemsId = data["_id"].stringValue
         let vc = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
         vc.itemsId = data["_id"].stringValue
         vc.SubCategoryId = data["sub_cat_id"].stringValue
         self.navigationController?.pushViewController(vc, animated: true)
         */
    }
}
extension BlogDetailsVC
{
    
    func Webservice_getBlogDetail(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getApiRespondeBlogModel = try jsonDecoder.decode(GetApiRespondeBlogModel.self, from: jsonResponse!)
                    self.blogItem=getApiRespondeBlogModel.blog
                    //self.Webservice_cartcount(url: urlString, params:params)
                      let myURL = URL(string:"https://api.adayroi.online/api/blogs/full_content/\(self.blogItem._id)")
                    self.lblBlogTitle.text = self.blogItem.title
                      let myRequest = URLRequest(url: myURL!)
                      self.DescriptionBlog.load(myRequest)
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    
    
    
    
    func Webservice_getRelatedBlogs(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getApiRespondeBlogsModel = try jsonDecoder.decode(GetApiRespondeBlogsModel.self, from: jsonResponse!)
                    self.list_blog_related=getApiRespondeBlogsModel.list_blog
                    self.CollectionViewRelatedBlogs.delegate = self
                    self.CollectionViewRelatedBlogs.dataSource = self
                    self.CollectionViewRelatedBlogs.reloadData()
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
    }
    func webViewDidFinishLoad(_ aWebView: UIWebView) {
        
        aWebView.scrollView.isScrollEnabled = false
        var frame = aWebView.frame
        
        frame.size.width = 200
        frame.size.height = 1
        
        aWebView.frame = frame
        frame.size.height = aWebView.scrollView.contentSize.height
        
        aWebView.frame = frame;
    }
    
    
}
