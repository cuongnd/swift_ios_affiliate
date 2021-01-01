//
//  DataRowModel.swift
//  AdayroiAffiliate
//
//  Created by cuongnd on 12/23/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import UIKit
import Foundation
public enum RowType {
    
    //MARK: - Properties
    case Text
    case Buttom
    case Select
    case UiView
}

public struct DataRowModel {
    var type: RowType
    var text: DataTableValueType
    var key_column: String=""
    var column_width:Int=50
    var column_height:Int=50
    var UiView:UIView?=nil
    var order: Int=0
}


