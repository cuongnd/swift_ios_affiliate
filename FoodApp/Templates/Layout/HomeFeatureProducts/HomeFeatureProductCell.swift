//
//  FeatureProductsCollectionViewCell.swift
//  FoodApp
//
//  Created by MAC OSX on 11/22/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit

@IBDesignable  class HomeFeatureProductCell: UICollectionViewCell
{
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var img_featureProduct: UIImageView!
    @IBOutlet weak var lbl_FeatureProductName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

