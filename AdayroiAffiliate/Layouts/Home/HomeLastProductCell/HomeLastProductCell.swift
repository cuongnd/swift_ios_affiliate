//
//  HomeLastProductCell.swift
//  FoodApp
//
//  Created by MAC OSX on 11/22/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit

class HomeLastProductCell: UICollectionViewCell {
    @IBOutlet weak var cell_view: UIView!
       @IBOutlet weak var img_product: UIImageView!
       @IBOutlet weak var lbl_ProductName: UILabel!
       @IBOutlet weak var lbl_LastProductPercent: UILabel!
      @IBOutlet weak var lbl_LastProductOriginalPrice: UILabel!
      @IBOutlet weak var lbl_LastProductUnitPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
