//
//  Webservices.swift
//  Best Quotes & Status
//
//  Created by ICON on 23/10/18.
//  Copyright © 2018 Gravity Infotech. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import SwiftyJSON
import MBProgressHUD

let reachability = Reachability()!

class WebServices: NSObject
{
    var operationQueue = OperationQueue()
    
    func CallGlobalAPI(url:String, headers:NSDictionary, parameters:NSDictionary, httpMethod:String, progressView:Bool, uiView:UIView, networkAlert:Bool, responseDict:@escaping (_ jsonResponce:JSON?, _ strErrorMessage:String) -> Void) {
        
        print("URL: \(url)")
        print("Headers: \n\(headers)")
        print("Parameters: \n\(parameters)")
        
        if progressView == true {
            self.ProgressViewShow(uiView:uiView)
        }
        let operation = BlockOperation.init {
            DispatchQueue.global(qos: .background).async {
                if self.internetChecker(reachability: Reachability()!) {
                    if (httpMethod == "POST") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = "POST"
                        req.allHTTPHeaderFields = headers as? [String:String]
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        req.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                        req.timeoutInterval = 30
                        print(req.curlString);
                        AF.request(req).responseJSON { response in
                            switch (response.result)
                            {
                            case .success:
                                if((response.value) != nil) {
                                    let jsonResponce = JSON(response.value!)
                                    print("Responce: \n\(jsonResponce)")
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonResponce,"")
                                    }
                                }
                                break
                            case .failure(let error):
                                let message : String
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Something Went Wrong..Try Again"
                                    case 401:
                                        message = "Something Went Wrong..Try Again"
                                        DispatchQueue.main.async {
                                            self.ProgressViewHide(uiView: uiView)
                                            responseDict([:],message)
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    let jsonError = JSON(response.error!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonError,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                    else if (httpMethod == "GET") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = "GET"
                        req.allHTTPHeaderFields = headers as? [String:String]
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        
                        req.timeoutInterval = 30
                        //req.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                        print(req.curlString);
                        AF.request(req).responseJSON { response in
                            switch (response.result)
                            {
                            case .success:
                                if((response.value) != nil) {
                                    let jsonResponce = JSON(response.value!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonResponce,"")
                                    }
                                }
                                break
                            case .failure(let error):
                                let message : String
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Something Went Wrong..Try Again"
                                    case 401:
                                        message = "Something Went Wrong..Try Again"
                                        DispatchQueue.main.async {
                                            self.ProgressViewHide(uiView: uiView)
                                            responseDict([:],message)
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    let jsonError = JSON(response.error!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonError,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                }
                else {
                    self.ProgressViewHide(uiView: uiView)
                    if networkAlert == true {
                        showAlertMessage(titleStr: "Error!", messageStr: MESSAGE_ERR_NETWORK)
                    }
                }
            }
        }
        operation.queuePriority = .normal
        operationQueue.addOperation(operation)
    }
    func CallGlobalAPIResponseData(url:String, headers:NSDictionary, parameters:NSDictionary, httpMethod:String, progressView:Bool, uiView:UIView, networkAlert:Bool, responseDict:@escaping (_ jsonResponce:Data?, _ strErrorMessage:String) -> Void) {
        
        print("URL: \(url)")
        print("Headers: \n\(headers)")
        print("Parameters: \n\(parameters)")
        
        if progressView == true {
            self.ProgressViewShow(uiView:uiView)
        }
        let operation = BlockOperation.init {
            DispatchQueue.global(qos: .background).async {
                if self.internetChecker(reachability: Reachability()!) {
                    if (httpMethod == "POST") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = "POST"
                        req.allHTTPHeaderFields = headers as? [String:String]
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        req.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                        req.timeoutInterval = 30
                        print(req.curlString);
                        AF.request(req).responseData { response in
                            switch (response.result)
                            {
                            case .success:
                                if((response.value) != nil) {
                                    let jsonResponce = Data(response.value!)
                                    print("Responce: \n\(jsonResponce)")
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonResponce,"")
                                    }
                                }
                                break
                            case .failure(let error):
                                let message : String
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Có lỗi phát sinh, xin vui lòng thử lại"
                                    case 401:
                                        message = "Có lỗi phát sinh, xin vui lòng thử lại"
                                        DispatchQueue.main.async {
                                            self.ProgressViewHide(uiView: uiView)
                                            responseDict(response.value,message)
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    let jsonError = Data(response.value!)
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(jsonError,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                    else if (httpMethod == "GET") {
                        var req = URLRequest(url: try! url.asURL())
                        req.httpMethod = "GET"
                        req.allHTTPHeaderFields = headers as? [String:String]
                        req.setValue("application/json", forHTTPHeaderField: "content-type")
                        req.timeoutInterval = 30
                        //req.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                        print(req.curlString);
                        AF.request(req).responseData { response in
                            switch (response.result)
                            {
                            case .success:
                                if((response.value) != nil) {
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(response.value,"")
                                    }
                                }
                                break
                            case .failure(let error):
                                let message : String
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "Có lỗi phát sinh, xin vui lòng thử lại"
                                    case 401:
                                        message = "Có lỗi phát sinh, xin vui lòng thử lại"
                                        DispatchQueue.main.async {
                                            self.ProgressViewHide(uiView: uiView)
                                            responseDict(response.value,message)
                                        }
                                    default: break
                                    }
                                } else {
                                    message = error.localizedDescription
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(response.value,"")
                                    }
                                }
                                break
                            }
                        }
                    }
                }
                else {
                    self.ProgressViewHide(uiView: uiView)
                    if networkAlert == true {
                        showAlertMessage(titleStr: "Lỗi!", messageStr: MESSAGE_ERR_NETWORK)
                    }
                }
            }
        }
        operation.queuePriority = .normal
        operationQueue.addOperation(operation)
    }
    func CallGlobalAPIResponseDataUpdateUser(method:HTTPMethod, URLString:String, encoding:Alamofire.ParameterEncoding, parameters:[String: Any], fileData:Data!, fileUrl:URL?, headers:HTTPHeaders, keyName:String,progressView:Bool, uiView:UIView, networkAlert:Bool, responseDict:@escaping (_ jsonResponce:Data?, _ strErrorMessage:String) -> Void) {
        
        
        
        print("Headers: \n\(headers)")
        print("Parameters: \n\(parameters)")
        if progressView == true {
            self.ProgressViewShow(uiView:uiView)
        }
        let operation = BlockOperation.init {
            DispatchQueue.global(qos: .background).async {
                if self.internetChecker(reachability: Reachability()!) {
                    
                    let af_upload:UploadRequest=AF.upload(multipartFormData: { MultipartFormData in
                        for (key, value) in parameters {
                            MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                        }
                        let name = randomString(length: 8)
                        if let data = fileData{
                            MultipartFormData.append(data, withName: keyName, fileName: "user_\(name).jpeg", mimeType: "image/jpeg")
                        }
                    }, to: URLString, method: .post, headers: headers);
                    af_upload.cURLDescription{ description in
                        print(description)
                    }
                    
                    af_upload.responseData { response in
                        switch (response.result)
                        {
                        case .success:
                            if((response.value) != nil) {
                                let jsonResponce = Data(response.value!)
                                print("Responce: \n\(jsonResponce)")
                                DispatchQueue.main.async {
                                    self.ProgressViewHide(uiView: uiView)
                                    responseDict(jsonResponce,"")
                                }
                            }
                            break
                        case .failure(let error):
                            let message : String
                            if let httpStatusCode = response.response?.statusCode {
                                switch(httpStatusCode) {
                                case 400:
                                    message = "Có lỗi phát sinh, xin vui lòng thử lại"
                                case 401:
                                    message = "Có lỗi phát sinh, xin vui lòng thử lại"
                                    DispatchQueue.main.async {
                                        self.ProgressViewHide(uiView: uiView)
                                        responseDict(response.value,message)
                                    }
                                default: break
                                }
                            } else {
                                message = error.localizedDescription
                                let jsonError = Data(response.value!)
                                DispatchQueue.main.async {
                                    self.ProgressViewHide(uiView: uiView)
                                    responseDict(jsonError,"")
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
        operation.queuePriority = .normal
        operationQueue.addOperation(operation)
        
        
        
        
        
        
        
        
    }
    
    
    
    
    func multipartWebService(method:HTTPMethod, URLString:String, encoding:Alamofire.ParameterEncoding, parameters:[String: Any], fileData:Data!, fileUrl:URL?, headers:HTTPHeaders, keyName:String, completion: @escaping (_ response:AnyObject?, _ error: NSError?) -> ()){
        
        print("Fetching WS : \(URLString)")
        print("With parameters : \(parameters)")
        
        if  !NetworkReachabilityManager()!.isReachable {
            showAlertMessage(titleStr: "Error!", messageStr: MESSAGE_ERR_NETWORK)
            return
        }
        
        
        let af_upload:UploadRequest=AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            let name = randomString(length: 8)
            if let data = fileData{
                MultipartFormData.append(data, withName: keyName, fileName: "user_\(name).jpeg", mimeType: "image/jpeg")
            }
        }, to: URLString, method: .post, headers: headers);
        af_upload.cURLDescription{ description in
            print(description)
        }
        af_upload.responseJSON { (response) in
            if let statusCode = response.response?.statusCode {
                if  statusCode == HttpResponseStatusCode.noAuthorization.rawValue {
                    showAlertMessage(titleStr: "Error!", messageStr: "Something went wrong.. Try again.")
                    return
                }
            }
            if let error = response.error {
                completion(nil, error as NSError?)
            }
            else {
                guard let data = response.data
                    else {
                        showAlertMessage(titleStr: "Error!", messageStr: "Something went wrong.. Try again.")
                        return
                }
                do {
                    let unparsedObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    completion(unparsedObject, nil)
                }
                catch let exception as NSError {
                    completion(nil, exception)
                }
            }
        }
    }
    
    func multipartWebServiceArray(method:HTTPMethod, URLString:String, encoding:Alamofire.ParameterEncoding, parameters:[String: Any], fileData:[Data], fileUrl:URL?, headers:HTTPHeaders, keyName:String, completion: @escaping (_ response:AnyObject?, _ error: NSError?) -> ()){
        
        print("Fetching WS : \(URLString)")
        print("With parameters : \(parameters)")
        
        if  !NetworkReachabilityManager()!.isReachable {
            showAlertMessage(titleStr: "Error!", messageStr: MESSAGE_ERR_NETWORK)
            return
        }
        
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            for data in fileData {
                let name = randomString(length: 8)
                MultipartFormData.append(data, withName: keyName, fileName: "product_\(name).jpeg", mimeType: "image/jpeg")
            }
        }, to: URLString, method: .post, headers: headers)
            .responseJSON { (response) in
                if let statusCode = response.response?.statusCode {
                    if  statusCode == HttpResponseStatusCode.noAuthorization.rawValue {
                        showAlertMessage(titleStr: "Error!", messageStr: "Something went wrong.. Try again.")
                        return
                    }
                }
                if let error = response.error {
                    completion(nil, error as NSError?)
                }
                else {
                    guard let data = response.data
                        else {
                            showAlertMessage(titleStr: "Error!", messageStr: "Something went wrong.. Try again.")
                            return
                    }
                    do {
                        let unparsedObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                        completion(unparsedObject, nil)
                    }
                    catch let exception as NSError {
                        completion(nil, exception)
                    }
                }
        }
    }
    
    func internetChecker(reachability: Reachability) -> Bool {
        var check:Bool = false
        if reachability.connection == .wifi {
            check = true
        }
        else if reachability.connection == .cellular {
            check = true
        }
        else {
            check = false
        }
        return check
    }
    
    func ProgressViewShow(uiView:UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: uiView, animated: true)
        }
    }
    
    func ProgressViewHide(uiView:UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for:uiView, animated: true)
        }
    }
    
}
extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
}
