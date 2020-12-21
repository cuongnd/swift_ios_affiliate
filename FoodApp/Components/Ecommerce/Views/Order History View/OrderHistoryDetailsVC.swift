//
//  OrderHistoryDetailsVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 09/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import TagListView
class historyOrderProductCell: UICollectionViewCell {
    
    @IBOutlet weak var UILabelColorValue: UILabel!
    @IBOutlet weak var UIImageViewColor: UIImageView!
    @IBOutlet weak var UIImageViewProduct: UIImageView!
    @IBOutlet weak var UILabelProductName: UILabel!
    @IBOutlet weak var UILabelPrice: UILabel!
    @IBOutlet weak var UILabelquality: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var UILabelTotal: UILabel!
    /*
     @IBOutlet weak var UILabelPrice: UILabel!
       @IBOutlet weak var UILabelquality: UILabel!
       @IBOutlet weak var UILabelTotal: UILabel!
       @IBOutlet weak var UILabelProductName: UILabel!
      
       @IBOutlet weak var UICollectionViewAttributeNameValue: UICollectionView!
    */
  
}

class OrderHistoryDetailsVC: UIViewController {
    
    @IBOutlet weak var btn_cancelHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var lbl_titleLabel: UILabel!
    var OrderNumber = String()
    var status = String()
    var OrderId:String=""
    var OrderDetailsData = [JSON]()
    var list_product:[OrderProductModel]=[OrderProductModel]()
    var taxStr = "Tax".localiz()
    @IBOutlet weak var UILabelOrderNumber: UILabel!
    @IBOutlet weak var UILabelCopyOrderNUmber: UILabel!
    @IBOutlet weak var UILabelOrderStatus: UILabel!
    @IBOutlet weak var UILabelTotalNumber: UILabel!
    @IBOutlet weak var UILabelTotalCostBeforTax: UILabel!
    @IBOutlet weak var UILabelDiscountAmount: UILabel!
    @IBOutlet weak var UILabelTotalCostAfterDiscount: UILabel!
    @IBOutlet weak var UILabelTax: UILabel!
    @IBOutlet weak var UILabelShippingAmout: UILabel!
    @IBOutlet weak var UILabelTaxPercent: UILabel!
    @IBOutlet weak var UILabelTotalCoustAfterTax: UILabel!
    @IBOutlet weak var UILabelShippingPhoneNumber: UILabel!
    @IBOutlet weak var UILabelShippingEmail: UILabel!
    @IBOutlet weak var UILabelShippingAddress1: UILabel!
    @IBOutlet weak var UILabelShippingAddress2: UILabel!
    @IBOutlet weak var UILabelBillingPhoneNumber: UILabel!
    @IBOutlet weak var UILabelBillingEmail: UILabel!
    @IBOutlet weak var UILabelBillingAddress1: UILabel!
    @IBOutlet weak var UILabelBillingAddress2: UILabel!
    @IBOutlet weak var UIImageViewColorImage: UIImageView!
    @IBOutlet weak var UIImageViewProductImage: UIImageView!
    @IBOutlet weak var UICollectionViewOrderProducts: UICollectionView!
    var driver_mobile = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "historyOrderProductCell", bundle: nil)
        self.UICollectionViewOrderProducts.register(nib, forCellWithReuseIdentifier: "cell")
        let urlString = API_URL + "/api/orders/\(self.OrderId)"
        self.Webservice_getOrderInfo(url: urlString, params:[:])
        
    }
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_Cancel(_ sender: UIButton) {
        let urlString = API_URL + "ordercancel"
        let params: NSDictionary = ["order_id":self.OrderId]
        self.Webservice_CancelOrder(url: urlString, params:params)
    }
    
    @IBAction func btnTap_Call(_ sender: UIButton) {
        callNumber(phoneNumber: self.driver_mobile)
    }
    func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
               UIApplication.shared.canOpenURL(url) else {
                   return
           }
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       }
    
}
extension OrderHistoryDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView==self.UICollectionViewOrderProducts){
            return self.list_product.count
        }else{
            return self.list_product[collectionView.tag].list_attribute_value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.UICollectionViewOrderProducts.dequeueReusableCell(withReuseIdentifier: "historyOrderProductCell", for: indexPath) as! historyOrderProductCell
        let element=self.list_product[indexPath.row]
        cell.UILabelPrice.text=String(element.unit_price)
        cell.UILabelProductName.text=element.product_name
        cell.UILabelTotal.text=String(element.total)
        
        cell.UILabelColorValue.text=element.color_value
        cell.UIImageViewColor.sd_setImage(with: URL(string: element.color_image), placeholderImage: UIImage(named: "placeholder_image"))
        cell.UIImageViewProduct.sd_setImage(with: URL(string: element.imageUrl), placeholderImage: UIImage(named: "placeholder_image"))
        
        cell.tagListView.textFont = UIFont.systemFont(ofSize: 14)
        cell.tagListView.alignment = .left // possible values are [.leading, .trailing, .left, .center, .right]
        for attribute in element.list_attribute_value{
            cell.tagListView.addTag("\(attribute.name):\(attribute.value)")
        }
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) / 1, height: 220.0)
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}




//MARK: Webservices
extension OrderHistoryDetailsVC {
     func Webservice_getOrderInfo(url:String, params:NSDictionary) -> Void {
           WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
               if strErrorMessage.count != 0 {
                   showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
               }
               else {
                   print(jsonResponse!)
                   do {
                       let jsonDecoder = JSONDecoder()
                       let getOrderResponseModel = try jsonDecoder.decode(GetOrderResponseModel.self, from: jsonResponse!)
                       let orderModel:OrderModel=getOrderResponseModel.order
                       self.list_product=orderModel.list_product;
                       self.UILabelOrderNumber.text=orderModel.order_number
                       self.UILabelBillingAddress1.text=orderModel.billing_address_1
                       self.UILabelBillingAddress2.text=orderModel.billing_address_2
                       self.UILabelBillingEmail.text=orderModel.billing_email
                       self.UILabelBillingPhoneNumber.text=orderModel.billing_phone
                       self.UILabelShippingAddress2.text=orderModel.shipping_address_2
                       self.UILabelShippingAddress1.text=orderModel.shipping_address_1
                       self.UILabelShippingEmail.text=orderModel.shipping_email
                       self.UILabelShippingPhoneNumber.text=orderModel.shipping_phone
                       self.UILabelTotalCoustAfterTax.text=String(orderModel.total)
                       self.UILabelShippingAmout.text="0.0"
                       self.UILabelTaxPercent.text="0.0"
                       self.UILabelOrderStatus.text=orderModel.order_status_id
                       self.UILabelTotalCostAfterDiscount.text=String(orderModel.total)
                       self.UILabelTotalCostAfterDiscount.text=String(orderModel.total)
                       self.UILabelTotalCostAfterDiscount.text=String(orderModel.total_item_count)
                       self.UICollectionViewOrderProducts.delegate=self
                       self.UICollectionViewOrderProducts.dataSource = self
                       self.UICollectionViewOrderProducts.reloadData()
                       print("orderModel:\(orderModel)")
                   } catch let error as NSError  {
                       print("error: \(error)")
                   }
                   
                   
                   //print("userModel:\(userModel)")
                   
               }
           }
           
           
           
       }
    func Webservice_CancelOrder(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: "", messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["status"].stringValue
                if responseCode == "1" {
                    //                    let responseData = jsonResponse!["data"].arrayValue
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    
}
