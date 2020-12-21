//
//  HomeDiscountProductCell.swift
//  FoodApp
//
//  Created by MAC OSX on 11/22/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit

class HomeDiscountProductCell: UICollectionViewCell {
    @IBOutlet weak var img_discount_product: UIImageView!
    @IBOutlet weak var lbl_DiscountProductName: UILabel!
    @IBOutlet weak var lbl_DiscountProductPercent: UILabel!
    @IBOutlet weak var lbl_DiscountProductOriginalPrice: UILabel!
    @IBOutlet weak var lbl_DiscountProductUnitPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
