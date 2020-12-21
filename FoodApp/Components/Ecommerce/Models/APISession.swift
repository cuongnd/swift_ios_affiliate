//
//  APISession.swift
//  FoodApp
//
//  Created by MAC OSX on 12/9/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class APISession {
    public static var shared = APISession()
    
    typealias response = Single<Data>
    
    func callApi(path:String,method_name:String,params:NSDictionary) -> response {
        var httpMethor:HTTPMethod = .post
        if(method_name.lowercased()=="get"){
            httpMethor = .get
        }
        let path = "/summary"
        
        return Single.create { [weak self] single in
            let request = AF.request(URL(string: API_URL + path)!, method: httpMethor, encoding: JSONEncoding.default).validate().responseData { (response) in
                switch response.result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
