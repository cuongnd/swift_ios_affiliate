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
    import RxSwift
    import RxCocoa
    import Foundation
    import Alamofire
    import SlideMenuControllerSwift
    class paymentCell: UICollectionViewCell {
        
        @IBOutlet weak var UIButtonSelectedPayment: UIButton!
        @IBOutlet weak var UIImageViewPayment: UIImageView!
        @IBOutlet weak var UILabelPaymentName: UILabel!
    }
    
    class ADRFrontEndViewCheckoutPaymentVC: UIViewController {
        
        
        @IBOutlet weak var UICollectionViewPayments: UICollectionView!
        @IBOutlet weak var UIButtonNext: UIButton!
        @IBOutlet weak var UIButtonBack: UIButton!
        var payments:[PaymentModel]=[PaymentModel]()
        override func viewDidLoad() {
            super.viewDidLoad()
            let urlStringPayment = API_URL + "/api/payments/list"
            self.Webservice_getPayments(url: urlStringPayment, params: [:])
            
            
            
            
        }
        @IBAction func UIButtonTouchUpInsideNext(_ sender: UIButton) {
            var payment_is_selected:Bool=false
            var paymentSelected:PaymentModel=PaymentModel();
            for index in 0...self.payments.count-1 {
                if(self.payments[index].isselected == 1){
                    payment_is_selected=true
                    paymentSelected=self.payments[index]
                }
            }
            if(!payment_is_selected){
                let alert = UIAlertController(title: "Thông báo", message: "Vui lòng lựa chọn phương thức thanh toán", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId)
            var totalProduct:Int64=0;
            var totalPrice:Int64=0;
            var cartDetailsarray = [[String:Any]]()
            
            if let itemsCart:AnySequence<Row> = ADRFrontEndModelCartItems.getList(){
                
                
                for item in itemsCart {
                    
                    do{
                        var attributes = [[String:Any]]()
                        let cart_id=try item.get(Expression<Int64>("id"))
                        if let itemsAtributeCart:AnySequence<Row> = ADRFrontEndModelCartItems.getAttributeListByCartId(cart_id: cart_id as! Int64){
                            for item in itemsAtributeCart {
                                do{
                                    
                                    let a_obj = [
                                        "product_id":try item.get(Expression<String>("product_id")),
                                        "name":try item.get(Expression<String>("name")),
                                        "value":try item.get(Expression<String>("value")),
                                        "attribute_id":try item.get(Expression<String>("attribute_id")),
                                        ] as [String : Any]
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
                            "product_id":try item.get(Expression<String>("product_id")),
                            "quantity":try item.get(Expression<Int64>("quality")),
                            "price":try item.get(Expression<Int64>("unit_price")),
                            "name":try item.get(Expression<String>("name")),
                            "imageUrl":try item.get(Expression<String>("image")),
                            "color_id":try item.get(Expression<String>("color_id")),
                            "color_name":try item.get(Expression<String>("color_name")),
                            "color_value":try item.get(Expression<String>("color_value")),
                            "color_image":try item.get(Expression<String>("color_image")),
                            "attributes":attributes,
                            ] as [String : Any]
                        
                        
                        
                        
                        
                        
                        cartDetailsarray.append(obj)
                    }catch{
                        let nsError=error as NSError
                        print("get value of column table Cart error. Error is \(nsError), \(nsError.userInfo)")
                    }
                    
                    
                }
            }
            var params_shipping: NSDictionary=[:]
            var params_billing: NSDictionary=[:]
            let user:Row!=ADRTableUser.shared.getUserInfoByUserId(user_id: user_id)
            if(user==nil){
                
            }else{
                do{
                    params_shipping = [
                        "full_name":try user.get(Expression<String>("shipping_fullname")),
                        "telephone":try user.get(Expression<String>("shipping_phone")),
                        "email":try user.get(Expression<String>("shipping_email")),
                        "address1":try user.get(Expression<String>("shipping_address_1")),
                        "address2":try user.get(Expression<String>("shipping_address_2"))
       
                    ];
                     params_billing = [
                                     "full_name":try user.get(Expression<String>("billing_fullname")),
                                     "email":try user.get(Expression<String>("billing_email")),
                                     "telephone":try user.get(Expression<String>("billing_phone")),
                                     "address1":try user.get(Expression<String>("billing_address_1")),
                                     "address2":try user.get(Expression<String>("billing_address_2"))
                    
                                 ];
                    
                    
                }catch{
                    let nsError=error as NSError
                    print("insert new table Cart error. Eoverride rror is \(nsError), \(nsError.userInfo)")
                }
            }
           let  params: NSDictionary=[
                "user_id":user_id,
                "total":totalPrice,
                "total_item_count":totalProduct,
                "payment_method_id":paymentSelected._id,
                "shipping":params_shipping,
                "billing":params_billing,
                "items":cartDetailsarray
            
            ];
            
            let urlStringOrderCreate = API_URL + "/api_task/orders.create"
            
            self.Webservice_getCreateOrder(url: urlStringOrderCreate, params: params)
            
            
        }
        @IBAction func UIButtonTouchUpInsideBack(_ sender: UIButton) {
            let vc = self.storyboard?.instantiateViewController(identifier: "ADRFrontEndViewCheckoutSummaryVC") as! ADRFrontEndViewCheckoutSummaryVC
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
    extension ADRFrontEndViewCheckoutPaymentVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return self.payments.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath) as! paymentCell
            let payment = self.payments[indexPath.row]
            cell.UILabelPaymentName.text! = payment.name
            cell.UIButtonSelectedPayment.tag = indexPath.row
            cell.UIImageViewPayment.sd_setImage(with: URL(string: payment.default_photo.img_path), placeholderImage: UIImage(named: "placeholder_image"))
            cell.UIButtonSelectedPayment.addTarget(self, action: #selector(SelectedPayment), for: .touchUpInside)
            
            cell.UILabelPaymentName.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapSelectedPayment))
            cell.UILabelPaymentName.isUserInteractionEnabled = true
            cell.UILabelPaymentName.addGestureRecognizer(tap)
            if payment.isselected == 1
            {
                cell.UIButtonSelectedPayment.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            }
            else{
                cell.UIButtonSelectedPayment.setImage(UIImage(systemName: "square"), for: .normal)
                
            }
            return cell
            
            
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (UIScreen.main.bounds.width) / 2, height: 120.0)
            
            
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
        }
        @objc func doubleTapSelectedPayment(sender: UITapGestureRecognizer) {
            for index in 0...self.payments.count-1 {
                self.payments[index].isselected=0
            }
            self.payments[sender.view?.tag ?? 0].isselected = 1;
            self.UICollectionViewPayments.delegate = self
            self.UICollectionViewPayments.dataSource = self
            self.UICollectionViewPayments.reloadData()
            
        }
        @objc func SelectedPayment(sender:UIButton)
        {
            let payment = self.payments[sender.tag]
            for index in 0...self.payments.count-1 {
                self.payments[index].isselected=0
            }
            
            self.payments[sender.tag].isselected = 1;
            self.UICollectionViewPayments.delegate = self
            self.UICollectionViewPayments.dataSource = self
            self.UICollectionViewPayments.reloadData()
            print("payment:payment \(payment)")
        }
        
        
    }
    
    extension ADRFrontEndViewCheckoutPaymentVC
    {
        
        func Webservice_getPayments(url:String, params:NSDictionary) -> Void {
            WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
                if strErrorMessage.count != 0 {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
                }
                else {
                    print(jsonResponse!)
                    do {
                        let jsonDecoder = JSONDecoder()
                        let getPaymentResponseModel = try jsonDecoder.decode(GetPaymentResponseModel.self, from: jsonResponse!)
                        self.payments=getPaymentResponseModel.payments
                        self.UICollectionViewPayments.delegate = self
                        self.UICollectionViewPayments.dataSource = self
                        self.UICollectionViewPayments.reloadData()
                    } catch let error as NSError  {
                        print("error: \(error)")
                    }
                    
                    
                    //print("userModel:\(userModel)")
                    
                }
            }
            
            
            
        }
        func Webservice_getCreateOrder(url:String, params:NSDictionary) -> Void {
            WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
                if strErrorMessage.count != 0 {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
                }
                else {
                    print(jsonResponse!)
                    let responseCode = jsonResponse!["result"].stringValue
                    if responseCode == "success" {
                        let data = jsonResponse!["data"].dictionaryValue
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["msg"].stringValue)
                        let vc = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(identifier: "ADRFrontEndViewCheckoutThankyouVC") as! ADRFrontEndViewCheckoutThankyouVC
                         vc.order_id=data["_id"]?.stringValue as! String
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                    }
                }
            }
        }
        
        
    }
