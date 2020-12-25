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
    lazy var dataTable = makeDataTable()
    var dataSource: DataTableContent = []
    @IBOutlet weak var UIViewLichSuRutTien: UIView!
    @IBOutlet weak var UILabelSoTienCoTheRut: UILabel!
    @IBOutlet weak var UILabelSoTIenDangSuLy: UILabel!
    @IBOutlet weak var UIButtonCaiDatTkNganHang: UIButton!
    @IBOutlet weak var UIButtonLapLenhRutTien: UIButton!
    let headerTitles = [
        DataRowModel(type: .Text, text:DataTableValueType.string("STT")),
        DataRowModel(type:.Text, text:DataTableValueType.string("Số tiền")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Ngày")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Trạng thái")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Action"))
        
    ]
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
                    var i=0;
                    
                    for rut_tien in self.rutTienList {
                        //RowModel
                        
                        i=i+1
                    }
                    
                    self.dataTable.reload()
                    
                    
                    
                    
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
extension WithdrawalListVC {
    private func makeDataTable() -> SwiftDataTable {
        let dataTable = SwiftDataTable(dataSource: self)
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.delegate = self
        return dataTable
    }
}
extension WithdrawalListVC: SwiftDataTableDataSource {
    public func dataTable(_ dataTable: SwiftDataTable, headerTitleForColumnAt columnIndex: NSInteger) -> String {
        return self.headerTitles[columnIndex].text.stringRepresentation
    }
    
    public func numberOfColumns(in: SwiftDataTable) -> Int {
        return self.headerTitles.count
    }
    
    func numberOfRows(in: SwiftDataTable) -> Int {
        return self.dataSource.count
    }
    
    public func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataRowModel] {
        return self.dataSource[index]
    }
}

extension WithdrawalListVC: SwiftDataTableDelegate {
    
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        //debugPrint("dataTable \(dataTable.data(for: indexPath))");
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
    
}

extension WithdrawalListVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawalCollectionViewCell.reuseID, for: indexPath) as? WithdrawalCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.titleLabel.text = "\(indexPath)"
        cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white

        return cell
    }
}

extension WithdrawalListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
