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
    lazy var dataTable = makeDataTable()
    var dataSource: DataTableContent = []
    @IBOutlet weak var UIViewLichSuRutTien: UIView!
    let headerTitles = ["STT", "Amout", "Date", "Status", "Action"]
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
    }
    override func viewWillAppear(_ animated: Bool) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/withdrawals/list?user_id=\(user_id)&limit=30&offset=0"
        self.Webservice_GetLichSuRutTien(url: urlString, params:[:])
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
                    let rutTienList:[RutTienModel]=getLichSuRutTienResponseModel.rutTienList
                    var i=1;
                    for rut_tien in rutTienList {
                        
                        self.dataSource.append([
                            DataTableValueType.string(String(i)),
                            DataTableValueType.string(rut_tien.amount),
                            DataTableValueType.string("20/10/20201"),
                            DataTableValueType.string(rut_tien.withdrawalstatus.name),
                            DataTableValueType.Btn("ation")
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
        return self.headerTitles[columnIndex]
    }
    
    public func numberOfColumns(in: SwiftDataTable) -> Int {
        return self.headerTitles.count
    }
    
    func numberOfRows(in: SwiftDataTable) -> Int {
        return self.dataSource.count
    }
    
    public func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataTableValueType] {
        return self.dataSource[index]
    }
}

extension WithdrawalListVC: SwiftDataTableDelegate {
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
}
