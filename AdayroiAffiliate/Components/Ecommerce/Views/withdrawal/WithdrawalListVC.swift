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
class WithdrawalLabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var UILabelText: UILabel!
    static let reuseID = "WithdrawalLabelCollectionViewCell"
}

class WithdrawalButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var UIButtonWithDrawal: UIButton!
    static let reuseID = "WithdrawalButtonCollectionViewCell"
}

//MARK: - Properties
private enum Properties {
    static let verticalMargin: CGFloat = 5
    static let horizontalMargin: CGFloat = 15
    static let widthConstant: CGFloat = 20
}
class WithdrawalListVC: UIViewController {
    var OrderHistoryData = [JSON]()
    var selected = String()
    var rutTienList:[RutTienModel]=[RutTienModel]();
    @IBOutlet weak var UIViewLichSuRutTien: UIView!
    @IBOutlet weak var UILabelSoTienCoTheRut: UILabel!
    @IBOutlet weak var UILabelSoTIenDangSuLy: UILabel!
    @IBOutlet weak var UIButtonCaiDatTkNganHang: UIButton!
    @IBOutlet weak var UIButtonLapLenhRutTien: UIButton!
    
    @IBAction func TouchUpInsideLapLenhRutTien(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawalLapLenhRutTienVC") as! WithdrawalLapLenhRutTienVC
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        VC.delegate = self
        self.present(VC,animated: true,completion: nil)
    }
    @IBAction func TouchUpInSideCaiDatTKNganHang(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawalCaiDatTKNganHangVC") as! WithdrawalCaiDatTKNganHangVC
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC,animated: true,completion: nil)
    }
    @IBOutlet weak var gridCollectionView: UICollectionView! {
        didSet {
            gridCollectionView.bounces = false
        }
    }
    
    @IBOutlet weak var gridLayout: WithdrawalStickyGridCollectionViewLayout! {
        didSet {
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 1
        }
    }
   let headerTitles = [
       DataRowModel(type: .Text, text:DataTableValueType.string("STT"),key_column: "stt",column_width: 50,column_height: 50),
       DataRowModel(type:.Text, text:DataTableValueType.string("Số tiền"),key_column: "",column_width: 100,column_height: 50),
       DataRowModel(type: .Text, text:DataTableValueType.string("Ngày"),key_column: "",column_width: 150,column_height: 50),
       DataRowModel(type: .Text, text:DataTableValueType.string("Trạng thái"),key_column: "",column_width: 150,column_height: 50),
       DataRowModel(type: .Text, text:DataTableValueType.string("Action"),key_column: "",column_width: 100,column_height: 50)
       
   ]
    var dataSource:[[DataRowModel]]=[[DataRowModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selected = ""
        gridCollectionView.delegate=self
        gridCollectionView.dataSource=self
        self.dataSource.append(self.headerTitles)
        
        
        
        
    }
    @objc private func refreshData(_ sender: Any) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetLichSuRutTien(url: urlString, params:[:])
        
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("hello viewWillAppear")
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetLichSuRutTien(url: urlString, params:[:])
        
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
        
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

extension WithdrawalListVC: WithdrawalLapLenhRutDelegate {
    
    func refreshData() {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetLichSuRutTien(url: urlString, params:[:])
        
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
    }
}

//MARK: WithdrawalList
extension WithdrawalListVC {
    
    
    func Webservice_GetLichSuRutTien(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getLichSuRutTienResponseModel = try jsonDecoder.decode(GetLichSuRutTienResponseModel.self, from: jsonResponse!)
                    self.rutTienList=getLichSuRutTienResponseModel.rutTienList
                    self.dataSource=[[DataRowModel]]()
                    var i=0;
                    self.dataSource.append(self.headerTitles)
                    let dataButton = UIButton()
                    dataButton.backgroundColor = UIColor( red: CGFloat(92/255.0), green: CGFloat(203/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0) )
                    dataButton.layer.cornerRadius = 5
                    dataButton.sizeToFit()
                    //dataButton.addTarget(self, action: #selector(btnTapMines), for: .touchUpInside)
                    
                    
                    
                    dataButton.setTitle("Xóa", for: .normal)
                    dataButton.translatesAutoresizingMaskIntoConstraints = false
                    
                    
                    
                    for rut_tien in self.rutTienList {
                        self.dataSource.append([
                            DataRowModel(type: .Text, text:DataTableValueType.init(i+1),key_column: "stt",column_width: 50,column_height: 50),
                            DataRowModel(type: .Text, text:DataTableValueType.string(LibraryUtilitiesUtility.format_currency(amount: UInt64(rut_tien.amount)!,decimalCount: 0)  ),key_column: "amount",column_width: 100,column_height: 50),
                            DataRowModel(type: .Text, text:DataTableValueType.string("20/20/2010"),key_column: "created_date",column_width: 150,column_height: 50),
                            DataRowModel(type: .Text, text:DataTableValueType.string(rut_tien.withdrawalstatus.name),key_column: "withdrawalstatus",column_width: 150,column_height: 50),
                            DataRowModel(type: .Buttom, text:DataTableValueType.string("Xóa"),key_column: "withdrawalstatus",column_width: 100,column_height: 50,UiView: dataButton)
                        ])
                        i += 1
                    }
                    
                    
                    self.gridCollectionView.reloadData()
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    func Webservice_GetDeleteWithdrawal(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getDeletewithdrawalModel = try jsonDecoder.decode(GetDeletewithdrawalModel.self, from: jsonResponse!)
                    debugPrint("getDeletewithdrawalModel \(getDeletewithdrawalModel)")
                    if(getDeletewithdrawalModel.result=="error"){
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: getDeletewithdrawalModel.errorMessage)
                    }else{
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Đã xóa thành công")
                    }
                    let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
                    
                    let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
                    self.Webservice_GetLichSuRutTien(url: urlString, params:[:])
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    
    func Webservice_GetAffiliateInfo(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getAffiliateInfoModel = try jsonDecoder.decode(GetAffiliateInfoModel.self, from: jsonResponse!)
                    let UserAffiliateInfoModel=getAffiliateInfoModel.userAffiliateInfoModel
                    self.UILabelSoTienCoTheRut.text=LibraryUtilitiesUtility.format_currency(amount: UInt64(UserAffiliateInfoModel.total),decimalCount: 0)
                    self.UILabelSoTIenDangSuLy.text=LibraryUtilitiesUtility.format_currency(amount: UInt64(UserAffiliateInfoModel.total_processing),decimalCount: 0) 
                    
                    
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
        
        
    }
    @objc func btnTapMines(sender:UIButton)
    {
        let tag=sender.tag
        let rutTien=self.rutTienList[tag]
        
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Bạn có chắc chắn muốn xóa không ?".localiz(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localiz(), style: .default) { (action) in
            
            let urlDeleteWithdrawal = API_URL + "//api_task/withdrawals.send_delete_withdrawal_now?id=\(rutTien._id)"
            self.Webservice_GetDeleteWithdrawal(url: urlDeleteWithdrawal, params:[:])
            
            
        }
        let noAction = UIAlertAction(title: "No".localiz(), style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC,animated: true,completion: nil)
        
        
        
        
    }
}

extension WithdrawalListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.rutTienList.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.headerTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row_index=indexPath[0]
        let column_index=indexPath[1]
        
        let current_rut_tien:DataRowModel=self.dataSource[row_index][column_index]
        //if header
        if(row_index==0){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalLabelCollectionViewCell.reuseID, for: indexPath) as? WithdrawalLabelCollectionViewCell else {
                      return UICollectionViewCell()
                  }
            cell.UILabelText.text=current_rut_tien.text.stringRepresentation
             cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
            return cell
        }else{
            if(current_rut_tien.type==RowType.Text){
                 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalLabelCollectionViewCell.reuseID, for: indexPath) as? WithdrawalLabelCollectionViewCell else {
                                      return UICollectionViewCell()
                                  }
                            cell.UILabelText.text=current_rut_tien.text.stringRepresentation
                             cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
                            return cell
                
             } else if(current_rut_tien.type==RowType.Buttom){
                 let data_row=self.rutTienList[row_index-1]
                 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalButtonCollectionViewCell.reuseID, for: indexPath) as? WithdrawalButtonCollectionViewCell else {
                                      return UICollectionViewCell()
                                  }
                cell.UIButtonWithDrawal.tag=row_index-1
                 cell.UIButtonWithDrawal.setTitle(current_rut_tien.text.stringRepresentation, for: .normal)
                  cell.UIButtonWithDrawal.addTarget(self, action: #selector(self.btnTapMines), for: .touchUpInside)
                 print("data_row.withdrawalstatus \(data_row.withdrawalstatus)")
                 if(data_row.withdrawalstatus.can_delete==1){
                     cell.UIButtonWithDrawal.isHidden=false
                 }else{
                      cell.UIButtonWithDrawal.isHidden=true
                 }
                  cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
                 return cell
             }
            return UICollectionViewCell()
            
        }
        
        
        
        
        
    }
}

extension WithdrawalListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row_index=indexPath[0]
        let column_index=indexPath[1]
        let item=self.dataSource[row_index][column_index]
        return CGSize(width: item.column_width, height: item.column_height)
    }
}
