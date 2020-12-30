//
//  HomeHeader.swift
//  FoodApp
//
//  Created by MAC OSX on 11/22/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
@objc protocol SubViewDelegate {
    func didTapOnMe( name : String , showMe : String)
}

@IBDesignable
class HomeHeader: UIView {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    var subViewDelegate : SubViewDelegate!
    /*    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame:frame)
        commitInit();
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commitInit()
    }
    func commitInit(){
        let bundle = Bundle(for: HomeHeader.self)
               
       let homeHeader=bundle.loadNibNamed("HomeHeader", owner: self, options: nil)![0] as! UIView
       addSubview(homeHeader)

    }
 
    @IBAction func touchUpOutSide(_ sender: Any) {
        subViewDelegate.didTapOnMe(name:  "name1" , showMe: "showMe1" )
    }
    
  

}
