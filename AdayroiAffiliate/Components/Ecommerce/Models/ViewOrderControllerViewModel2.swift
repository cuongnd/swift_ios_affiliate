//
//  ViewControllerViewModel.swift
//  FoodApp
//
//  Created by MAC OSX on 12/12/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
protocol ViewControllerViewModelInputs2 {
}

protocol ViewControllerViewModelOutPuts2 {
    var list_produt_attribute: PublishSubject<[OrderAttributeModel]> { get }
    
    var messageError: PublishSubject<String> { get }
}

protocol ViewControllerViewModelType2 {
    var inputs: ViewControllerViewModelInputs2 { get }
    var outputs: ViewControllerViewModelOutPuts2 { get }
}

class ViewOrderControllerViewModel2: ViewControllerViewModelType2, ViewControllerViewModelInputs2, ViewControllerViewModelOutPuts2 {
    
    var inputs: ViewControllerViewModelInputs2 { return self }
    var outputs: ViewControllerViewModelOutPuts2 { return self }
    private var disposeBag = DisposeBag()

    //MARK: - ViewControllerViewModelInputs
    
    //MARK: - ViewControllerViewModelOutPuts2
    
    var list_produt_attribute = PublishSubject<[OrderAttributeModel]>()
    
    var messageError = PublishSubject<String>()
    
    
    
}
