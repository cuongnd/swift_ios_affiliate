//
//  OrderHistoryVC.swift
//  FoodApp
//
//  Created by Mitesh's MAC on 07/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDataTables



class WithdrawalListVC: UIViewController {
    var OrderHistoryData = [JSON]()
    var selected = String()
    lazy var dataTable = makeDataTable()
    var dataSource: DataTableContent = []
    @IBOutlet weak var UIViewLichSuRutTien: UIView!
    let headerTitles = ["Name", "Fav Beverage", "Fav language", "Short term goals", "Height"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selected = ""
        
        setupViews()
        setupConstraints()
        
        
        
    }
    @objc private func refreshData(_ sender: Any) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/orders/my_list_order/limit/30/start/0?user_id=\(user_id)"
        self.Webservice_GetHistory(url: urlString, params:[:])
    }
    override func viewWillAppear(_ animated: Bool) {
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId);
        let urlString = API_URL + "/api/orders/my_list_order/limit/30/start/0?user_id=\(user_id)"
        self.Webservice_GetHistory(url: urlString, params:[:])
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
        dataSource = [
            [
                DataTableValueType.string("Pavan"),
                DataTableValueType.string("Juice"),
                DataTableValueType.string("Swift and Php"),
                DataTableValueType.string("Be a game publisher"),
                DataTableValueType.float(175.25)
            ],
            [
                DataTableValueType.string("NoelDavies"),
                DataTableValueType.string("Water"),
                DataTableValueType.string("Php and Javascript"),
                DataTableValueType.string("'Be a fucking paratrooper machine'"),
                DataTableValueType.float(185.80)
            ],
            [
                DataTableValueType.string("Redsaint"),
                DataTableValueType.string("Cheerwine and Dr.Pepper"),
                DataTableValueType.string("Java"),
                DataTableValueType.string("'Creating an awesome RPG Game game'"),
                DataTableValueType.float(185.42)
            ],
        ]
        dataTable.reload()
        
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
    func Webservice_GetHistory(url:String, params:NSDictionary) -> Void {
        
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: "", messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                    let responseData = jsonResponse!["list_order"].arrayValue
                    self.OrderHistoryData = responseData
                    self.selected = ""
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
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
        return 4
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
