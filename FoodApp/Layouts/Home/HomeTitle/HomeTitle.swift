//
//  HomeTitle.swift
//  FoodApp
//
//  Created by MAC OSX on 11/22/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
@IBDesignable
class HomeTitle: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var goToDetail: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable public var titleText: String = "" {
        didSet {
            self.title.text = titleText
        }
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        commitInit();
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commitInit()
    }
    func commitInit(){
        let bundle = Bundle(for: HomeTitle.self)
        //let viewHomeTitle=bundle.loadNibNamed("HomeTitle", owner: self, options: nil)
        
        let viewHomeTitle=bundle.loadNibNamed("HomeTitle", owner: self, options: nil)![0] as! UIView
        addSubview(viewHomeTitle)
    }
    

}
