//
//  test2.swift
//  FoodApp
//
//  Created by MAC OSX on 11/26/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
@IBDesignable
class test2: UIView {

    /*
    // Only override draw() if you perform custom drawing.
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
        let bundle = Bundle(for: test2.self)
        //let viewHomeTitle=bundle.loadNibNamed("HomeTitle", owner: self, options: nil)
        
        let test2=bundle.loadNibNamed("test2", owner: self, options: nil)![0] as! UIView
        addSubview(test2)
    }
}
