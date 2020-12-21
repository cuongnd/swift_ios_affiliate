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
protocol ViewControllerViewModelInputs {
}

protocol ViewControllerViewModelOutPuts {
    var list_produt: PublishSubject<[OrderProductModel]> { get }
    var list_produt_attribute: PublishSubject<[OrderAttributeModel]> { get }
    
    var messageError: PublishSubject<String> { get }
}

protocol ViewControllerViewModelType {
    var inputs: ViewControllerViewModelInputs { get }
    var outputs: ViewControllerViewModelOutPuts { get }
}

class ViewOrderControllerViewModel: ViewControllerViewModelType, ViewControllerViewModelInputs, ViewControllerViewModelOutPuts {
    
    var inputs: ViewControllerViewModelInputs { return self }
    var outputs: ViewControllerViewModelOutPuts { return self }
    private var disposeBag = DisposeBag()

    //MARK: - ViewControllerViewModelInputs
    
    //MARK: - ViewControllerViewModelOutPuts
    
    var list_produt = PublishSubject<[OrderProductModel]>()
    var list_produt_attribute = PublishSubject<[OrderAttributeModel]>()
    
    var messageError = PublishSubject<String>()
    
    
    
}
