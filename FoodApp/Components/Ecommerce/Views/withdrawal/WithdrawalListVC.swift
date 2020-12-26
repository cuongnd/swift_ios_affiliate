//
//  OrderHistoryVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class WithdrawalCollectionViewCell: UICollectionViewCell {
    static let reuseID = "WithdrawalCollectionViewCell"
    @IBOutlet weak var titleLabel: UILabel!
}
class WithdrawalCollectionViewCellButtom: UICollectionViewCell {
    static let reuseID = "WithdrawalCollectionViewCellButtom"
    
    @IBOutlet weak var UIButtonAction: UIButton!
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
        DataRowModel(type: .Text, text:DataTableValueType.string("STT")),
        DataRowModel(type:.Text, text:DataTableValueType.string("Số tiền")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Ngày")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Trạng thái")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Action"))
        
    ]
    var dataSource:[[DataRowModel]]=[[DataRowModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selected = ""
        gridCollectionView.delegate=self
        gridCollectionView.dataSource=self
        
        
        
        
        
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
                    print("getLichSuRutTienResponseModel \(getLichSuRutTienResponseModel)")
                    self.rutTienList=getLichSuRutTienResponseModel.rutTienList
                    self.gridCollectionView.reloadData()
                    var i=0;
                    for rut_tien in self.rutTienList {
                        
                        self.dataSource.append([
                            DataRowModel(type: .Text, text:DataTableValueType.init(i+1)),
                            DataRowModel(type: .Text, text:DataTableValueType.string(rut_tien.amount)),
                            DataRowModel(type: .Text, text:DataTableValueType.string("20/20/2010")),
                            DataRowModel(type: .Text, text:DataTableValueType.string(rut_tien.withdrawalstatus.name))
                            
                        ])
                        i=i+1
                    }
                    
                    
                    
                    
                    
                    
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
                    let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Đã xóa thành công")
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
                    self.UILabelSoTienCoTheRut.text=String(UserAffiliateInfoModel.total)
                    self.UILabelSoTIenDangSuLy.text=String(UserAffiliateInfoModel.total_processing)
                    
                    
                    
                    
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
        print("rutTien \(rutTien)")
        
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
        return self.rutTienList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath[0]==0){
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalCollectionViewCell.reuseID, for: indexPath) as? WithdrawalCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = headerTitles[indexPath[1]].text.stringRepresentation
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
            
            return cell
            
        }else if(indexPath[0]>0 && indexPath[1]==4){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalCollectionViewCellButtom.reuseID, for: indexPath) as? WithdrawalCollectionViewCellButtom else {
                return UICollectionViewCell()
            }
            
            cell.UIButtonAction.setTitle("Xóa", for: .normal)
            cell.UIButtonAction.backgroundColor = .clear
            cell.UIButtonAction.layer.cornerRadius = 5
            cell.UIButtonAction.layer.borderWidth = 1
            cell.UIButtonAction.layer.borderColor = UIColor.black.cgColor
            
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
            
            return cell
            
            
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalCollectionViewCell.reuseID, for: indexPath) as? WithdrawalCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = self.dataSource[indexPath[0]][indexPath[1]].text.stringRepresentation
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
            
            return cell
        }
        
    }
}

extension WithdrawalListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row_index=indexPath[0]
        let column_index=indexPath[1]
        if(row_index==0){
            if(row_index==0 && column_index>0){
                return CGSize(width: 100, height: 50)
            }
            else
            {
                return CGSize(width: 50, height: 50)
            }
            
            
        }else if(row_index>0 && column_index==4){
            return CGSize(width: 100, height: 50)
            
            
        }else{
            if(row_index>0 && column_index==0){
                return CGSize(width: 50, height: 50)
            }
            else
            {
                return CGSize(width: 100, height: 50)
            }
        }
        
        
        
    }
}
