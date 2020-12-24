//
//  OrderHistoryVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON



class WithdrawalListVC: UIViewController {
    var OrderHistoryData = [JSON]()
    var selected = String()
    var rutTienList:[RutTienModel]=[RutTienModel]();
    lazy var dataTable = makeDataTable()
    var dataSource: DataTableContent = []
    @IBOutlet weak var UIViewLichSuRutTien: UIView!
    @IBOutlet weak var UILabelSoTienCoTheRut: UILabel!
    @IBOutlet weak var UILabelSoTIenDangSuLy: UILabel!
    let headerTitles = [
        DataRowModel(type: .Text, text:DataTableValueType.string("STT")),
        DataRowModel(type:.Text, text:DataTableValueType.string("Số tiền")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Ngày")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Trạng thái")),
        DataRowModel(type: .Text, text:DataTableValueType.string("Action"))
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selected = ""
        
        setupViews()
        setupConstraints()
        
        
        
    }
    @objc private func refreshData(_ sender: Any) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetLichSuRutTien(url: urlString, params:[:])
        
        let urlAffiliateInfo = API_URL + "/api_task/users.get_user_affiliate_info_by_id?user_id=\(user_id)"
        self.Webservice_GetAffiliateInfo(url: urlAffiliateInfo, params:[:])
        
    }
    override func viewWillAppear(_ animated: Bool) {
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
    func setupViews() {
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isTranslucent = false
        title = "Streaming fans"
        self.UIViewLichSuRutTien.backgroundColor = UIColor.white
        self.UIViewLichSuRutTien.addSubview(dataTable)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: self.UIViewLichSuRutTien.layoutMarginsGuide.topAnchor),
            dataTable.leadingAnchor.constraint(equalTo: self.UIViewLichSuRutTien.leadingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: self.UIViewLichSuRutTien.layoutMarginsGuide.bottomAnchor),
            dataTable.trailingAnchor.constraint(equalTo: self.UIViewLichSuRutTien.trailingAnchor),
        ])
    }
    
    public func addDataSourceAfter(){
        
        
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
                    var i=0;
                    for rut_tien in self.rutTienList {
                        //RowModel
                        let dataButton = UIButton()
                        dataButton.setTitle("Xóa", for: .normal)
                        
                        dataButton.backgroundColor = UIColor( red: CGFloat(92/255.0), green: CGFloat(203/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0) )
                        dataButton.layer.cornerRadius = 5
                        dataButton.sizeToFit()
                        dataButton.tag=i
                        dataButton.addTarget(self, action: #selector(self.btnTapMines), for: .touchUpInside)
                        self.dataSource.append([
                            DataRowModel(type: .Text, text:DataTableValueType.init(i+1)),
                            DataRowModel(type: .Text, text:DataTableValueType.string(rut_tien.amount)),
                            DataRowModel(type: .Text, text:DataTableValueType.string("20/20/2010")),
                            DataRowModel(type: .Text, text:DataTableValueType.string(rut_tien.withdrawalstatus.name)),
                            DataRowModel(type: .UiView, text:DataTableValueType.string("Xóa"),key_column: "delete",UiView: dataButton)
                        ])
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
    func Webservice_GetAffiliateInfo(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getLichSuRutTienResponseModel = try jsonDecoder.decode(GetAffiliateInfoModel.self, from: jsonResponse!)
                    let UserAffiliateInfoModel=getLichSuRutTienResponseModel.userAffiliateInfoModel
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
        print("tag \(tag)")
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
