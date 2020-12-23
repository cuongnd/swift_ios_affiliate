//
//  DataRowModel.swift
//  FoodApp
//
//  Created by cuongnd on 12/23/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import Foundation
public enum RowType {
    
    //MARK: - Properties
    case Text
    case Buttom
    case Select
}

public struct DataRowModel {
    var type: RowType
    var text: String
}
