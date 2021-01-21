//
//  EditProfileVC.swift
//  AdayroiVendor
//
//  Created by Mitesh's MAC on 06/06/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import Alamofire

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var btn_Camera: UIButton!
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    
    @IBOutlet weak var lbl_titleLabel: UILabel!
    var user:UserModel=UserModel()
    
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_titleLabel.text = "Edit Profile".localiz()
        self.btn_save.setTitle("Save".localiz(), for: .normal)
        self.txt_Email.isEnabled = false
        self.txt_Mobile.isEnabled = false
        cornerRadius(viewName: self.img_Profile, radius: self.img_Profile.frame.height / 2)
        cornerRadius(viewName: self.btn_Camera, radius: self.btn_Camera.frame.height / 2)
        cornerRadius(viewName: self.btn_save, radius: 8)
        setBorder(viewName: self.img_Profile, borderwidth: 3, borderColor: UIColor.white.cgColor, cornerRadius: self.img_Profile.frame.height / 2)
          let urlString = API_URL + "/api/users/"+String(UserDefaults.standard.value(forKey: UD_userId) as! String)
              let params: NSDictionary = [:]
              self.Webservice_GetProfile(url: urlString, params: params)
        
    }
    
    @IBAction func btnTap_Menu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTap_Save(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let imageData = self.img_Profile.image!.jpegData(compressionQuality: 0.5)
        
        let urlString = API_URL + "/api_task/user.update"
        let params = ["name":self.txt_Name.text!,
                      "user_id":UserDefaultManager.getStringFromUserDefaults(key: UD_userId),
                      "image":imageData!] as [String : Any]
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        WebServices().multipartWebService(method:.post, URLString:urlString, encoding:JSONEncoding.default, parameters:params, fileData:imageData!, fileUrl:nil, headers:headers, keyName:"image") { (response, error) in
            
            MBProgressHUD.hide(for: self.view, animated: false)
            if error != nil {
                showAlertMessage(titleStr: "", messageStr: error!.localizedDescription)
            }
            else {
                print(response!)
                let responseData = response as! NSDictionary
                let responseCode = responseData.value(forKey: "status") as! NSNumber
                let responseMsg = responseData.value(forKey: "message") as! String
                if responseCode == 1 {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    showAlertMessage(titleStr: "", messageStr: responseMsg)
                }
            }
        }
    }
    @IBAction func btnTap_camera(_ sender: UIButton) {
        self.imagePicker.delegate = self
        let alert = UIAlertController(title: "", message: "Select image".localiz(), preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel)
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.img_Profile.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: Webservices
extension EditProfileVC {
    func Webservice_GetProfile(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPIResponseData(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:Data? , _ strErrorMessage:String) in
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                do {
                    let jsonDecoder = JSONDecoder()
                    let getApiRespondeUser = try jsonDecoder.decode(GetApiRespondeUser.self, from: jsonResponse!)
                    if(getApiRespondeUser.result=="success"){
                        self.user = getApiRespondeUser.user
                        self.txt_Name.text = self.user.fullname
                        self.txt_Email.text = self.user.email
                        self.txt_Mobile.text = self.user.phonenumber
                        if self.user.default_photo?.img_path != "" {
                            self.img_Profile.sd_setImage(with: URL(string: self.user.default_photo!.img_path), placeholderImage: UIImage(named: "placeholder_image"))
                        }
                    }
                    
                } catch let error as NSError  {
                    print("url \(url)")
                    print("error : \(error)")
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Có lỗi phát sinh")
                    
                }
                
                
                //print("userModel:\(userModel)")
                
            }
        }
        
        
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "GET", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                let user = jsonResponse!.dictionaryValue
                print(user)
                if user["image"] != nil {
                    let userImage = user["image"]!.dictionaryValue
                    let userImagePath = userImage["img_path"]!.stringValue
                    self.img_Profile.sd_setImage(with: URL(string: userImagePath), placeholderImage: UIImage(named: "placeholder_image"))
                }
                self.txt_Name.text = user["fullname"]?.stringValue
                self.txt_Email.text = user["email"]?.stringValue
                self.txt_Mobile.text = user["phonenumber"]?.stringValue
            }
        }
    }
    
}
