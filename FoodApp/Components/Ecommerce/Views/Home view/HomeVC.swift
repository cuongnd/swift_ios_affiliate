//
//  HomeVC.swift
//  FoodApp
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
              pieChartUpdate()
        
       
       
        let urlStringDoanhThuTheoThang = API_URL + "/api/affiliates/get_doanh_thu_theo_thang"
        self.Webservice_getDoanhThuTheoThang(url: urlStringDoanhThuTheoThang, params: [:])
        
       
        

   }
    
       
       func pieChartUpdate () {
           
           // Basic set up of plan chart
           
           let entry1 = PieChartDataEntry(value: Double(24), label: "#1")
           let entry2 = PieChartDataEntry(value: Double(49), label: "#2")
           let entry3 = PieChartDataEntry(value: Double(32), label: "#3")
        let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3], label: "Widget Types")
           let data = PieChartData(dataSet: dataSet)
           pieChart.data = data
           pieChart.chartDescription?.text = "Share of Widgets by Type"

           // Color
           dataSet.colors = ChartColorTemplates.joyful()
           //dataSet.valueColors = [UIColor.black]
           pieChart.backgroundColor = UIColor.white
           pieChart.holeColor = UIColor.clear
           pieChart.chartDescription?.textColor = UIColor.black
           pieChart.legend.textColor = UIColor.black
           
           // Text
           pieChart.legend.font = UIFont(name: "Futura", size: 10)!
           pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!
           pieChart.chartDescription?.xOffset = pieChart.frame.width
           pieChart.chartDescription?.yOffset = pieChart.frame.height * (2/3)
           pieChart.chartDescription?.textAlign = NSTextAlignment.left

           // Refresh chart with new data
           pieChart.notifyDataSetChanged()
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
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["result"].stringValue
                if responseCode == "success" {
                     let doanh_theo_thang = jsonResponse!["data"].dictionaryValue
                     
                    let entry1 = BarChartDataEntry(x: 1.0, y: Double(10))
                              let entry2 = BarChartDataEntry(x: 2.0, y: Double(40))
                              let entry3 = BarChartDataEntry(x: 3.0, y: Double(30))
                           let dataSet = BarChartDataSet(entries: [entry1, entry2, entry3], label: "Widgets Type")
                              let data = BarChartData(dataSets: [dataSet])
                              self.barChart.data = data
                              self.barChart.chartDescription?.text = ""

                              // Color
                              dataSet.colors = ChartColorTemplates.vordiplom()

                              // Refresh chart with new data
                              self.barChart.notifyDataSetChanged()
                     
                    
                    
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["message"].stringValue)
                }
            }
        }
    }
    
}

