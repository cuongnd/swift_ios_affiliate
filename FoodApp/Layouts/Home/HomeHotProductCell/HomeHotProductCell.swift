//
//  HomeHotProductCell.swift
//  FoodApp
//
//  Created by MAC OSX on 11/22/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit

class HomeHotProductCell: UICollectionViewCell {
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var img_hot_product: UIImageView!
    @IBOutlet weak var lbl_HotProductName: UILabel!
    @IBOutlet weak var lbl_HotProductPercent: UILabel!
    @IBOutlet weak var lbl_HotProductOriginalPrice: UILabel!
    @IBOutlet weak var lbl_HotProductUnitPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
