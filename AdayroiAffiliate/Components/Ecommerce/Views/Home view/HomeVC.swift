//
//  HomeVC.swift
//  AdayroiAffiliate
//
//  Created by Mitesh's MAC on 04/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import LanguageManager_iOS
import SlideMenuControllerSwift
import CoreLocation
import MapKit
import Charts


class HomeCategoryCell: UICollectionViewCell {
    @IBOutlet weak var img_category: UIImageView!
    @IBOutlet weak var lbl_CategoryName: UILabel!
    
    
}

class HomeVC: UIViewController {
    
    
    
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    var lastProductArray = [JSON]()
    var homeHotCategoryArray = [JSON]()
    var homeHotProductArray = [JSON]()
    var homeDiscountProductArray = [JSON]()
    var homeCategoryArray = [JSON]()
    var homeFeatureProductArray = [JSON]()
    var pageIndex = 1
    var lastIndex = 0
    var SelectedCategoryId = String()
    var selectedindex = 0
    var latitued = String()
    var longitude = String()
    
    
    
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let user_id:String=UserDefaultManager.getStringFromUserDefaults(key: UD_userId)
        let urlStringDoanhThuTheoThang = API_URL + "/api/affiliates/get_doanh_thu_theo_thang?user_id=\(user_id)"
        self.Webservice_getDoanhThuTheoThang(url: urlStringDoanhThuTheoThang, params: [:])
        let urlStringHieuQuaDonHang = API_URL + "//api/affiliates/get_hieu_qua_don_hang?user_id=\(user_id)"
        self.Webservice_getHieuQuaDonHang(url: urlStringHieuQuaDonHang, params: [:])
        
        
        
        
    }
    
    
    
    @IBAction func GoToSearch(_ sender: UIButton) {
        let searchVC = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(identifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func ShowMenu(_ sender: UIButton) {
        print("hello ShowMenu")
        if UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "en" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "" || UserDefaultManager.getStringFromUserDefaults(key: UD_isSelectLng) == "N/A"
        {
            self.slideMenuController()?.openLeft()
        }
        else {
            self.slideMenuController()?.openRight()
        }
    }
    
    @IBAction func GoToCart(_ sender: UIButton) {
        let addtoCartVC = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(identifier: "AddtoCartVC") as! AddtoCartVC
        self.navigationController?.pushViewController(addtoCartVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    
}


extension HomeVC
{
    func Webservice_getDoanhThuTheoThang(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getDoanhThuTheoThangResponseModel = try jsonDecoder.decode(GetDoanhThuTheoThangResponseModel.self, from: jsonResponse!)
                    let list_doanhthu:[DoanhThuThangModel]=getDoanhThuTheoThangResponseModel.list_doanhthu
                    var listBarChartDataEntry = [BarChartDataEntry]()
                    for doanh_thu in list_doanhthu {
                        let entry = BarChartDataEntry(x: Double(doanh_thu.month), y: doanh_thu.total)
                        listBarChartDataEntry.append(entry)
                    }
                    let dataSet = BarChartDataSet(entries: listBarChartDataEntry, label: "")
                    let data = BarChartData(dataSets: [dataSet])
                    self.barChart.data = data
                    self.barChart.chartDescription?.text = ""
                    // Color
                    dataSet.colors = ChartColorTemplates.vordiplom()
                    self.barChart.doubleTapToZoomEnabled=false
                    // Refresh chart with new data
                    self.barChart.notifyDataSetChanged()
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
        
    }
    
    func Webservice_getHieuQuaDonHang(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getHieuQuaDonHangResponseModel = try jsonDecoder.decode(GetHieuQuaDonHangResponseModel.self, from: jsonResponse!)
                    let hieuQuaDonHangModel:HieuQuaDonHangModel=getHieuQuaDonHangResponseModel.hieuQuaDonHangModel
                    
                    let cancel_percent = PieChartDataEntry(value: Double(hieuQuaDonHangModel.cancel_percent), label: "Đơn hàng hủy")
                    let completed_percent = PieChartDataEntry(value: Double(hieuQuaDonHangModel.completed_percent), label: "Đơn hàng hoàn thành")
                    let in_process_percent = PieChartDataEntry(value: Double(hieuQuaDonHangModel.in_process_percent), label: "Đơn hàng đang sử lý")
                    let pending_percent = PieChartDataEntry(value: Double(hieuQuaDonHangModel.pending_percent), label: "Đơn hàng đang chờ sử lý")
                    let dataSet = PieChartDataSet(entries: [cancel_percent, completed_percent, in_process_percent,pending_percent], label: "")
                    let data = PieChartData(dataSet: dataSet)
                    self.pieChart.data = data
                    self.pieChart.chartDescription?.text = ""
                    
                    // Color
                    dataSet.colors = ChartColorTemplates.joyful()
                    //dataSet.valueColors = [UIColor.black]
                    self.pieChart.backgroundColor = UIColor.white
                    self.pieChart.holeColor = UIColor.clear
                    self.pieChart.chartDescription?.textColor = UIColor.black
                    self.pieChart.legend.textColor = UIColor.black
                    
                    // Text
                    self.pieChart.legend.font = UIFont(name: "Futura", size: 10)!
                    self.pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!
                    self.pieChart.chartDescription?.xOffset = self.pieChart.frame.width
                    self.pieChart.chartDescription?.yOffset = self.pieChart.frame.height * (2/3)
                    self.pieChart.chartDescription?.textAlign = NSTextAlignment.left
                    
                    // Refresh chart with new data
                    self.pieChart.notifyDataSetChanged()
                    
                    
                } catch let error as NSError  {
                    print("error: \(error)")
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        
       
    }
    
    
}

