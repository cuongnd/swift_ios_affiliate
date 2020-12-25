//
//  DataCell.swift
//  SwiftDataTables
//
//  Created by Pavan Kataria on 22/02/2017.
//  Copyright © 2017 Pavan Kataria. All rights reserved.
//

import UIKit
import Foundation
class DataCell: UICollectionViewCell {
    
    //MARK: - Properties
    private enum Properties {
        static let verticalMargin: CGFloat = 5
        static let horizontalMargin: CGFloat = 15
        static let widthConstant: CGFloat = 20
    }
    
    let dataLabel = UILabel()
    let dataButton = UIButton()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
    }
    
    func configure(_ viewModel: DataCellViewModel){
        switch viewModel.data.type {
        case RowType.Text:
            self.dataLabel.text = viewModel.data.text.stringRepresentation
            dataLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(dataLabel)
            NSLayoutConstraint.activate([
                dataLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Properties.widthConstant),
                dataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Properties.verticalMargin),
                dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Properties.verticalMargin),
                dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Properties.horizontalMargin),
                dataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Properties.horizontalMargin),
            ])
            //to do
            break
        case RowType.Buttom:
            self.dataButton.backgroundColor = UIColor( red: CGFloat(92/255.0), green: CGFloat(203/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0) )
            self.dataButton.layer.cornerRadius = 5
            self.dataButton.sizeToFit()
            //dataButton.addTarget(self, action: #selector(btnTapMines), for: .touchUpInside)
            
            
            
            self.dataButton.setTitle(viewModel.data.text.stringRepresentation, for: .normal)
            self.dataButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(self.dataButton)
            NSLayoutConstraint.activate([
                dataButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Properties.widthConstant),
                dataButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Properties.verticalMargin),
                dataButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Properties.verticalMargin),
                dataButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Properties.horizontalMargin),
                dataButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Properties.horizontalMargin),
            ])
            //to do
            break
        case RowType.UiView:
            let currentUiView:UIView=viewModel.data.UiView!;
            if(currentUiView != nil){
                currentUiView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(currentUiView)
                NSLayoutConstraint.activate([
                    currentUiView.topAnchor.constraint(equalTo: topAnchor),
                    currentUiView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    currentUiView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    currentUiView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
            //to do
            break
        default:
            //to do
            break
        }
        
        
        //        self.contentView.backgroundColor = .white
    }
    
}
