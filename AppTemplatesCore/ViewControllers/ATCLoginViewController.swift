//
//  ATCLoginViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/6/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import FacebookCore
import FacebookLogin
import Firebase
import FirebaseAuth
import TwitterKit
import UIKit

let kLoginButtonBackgroundColor = UIColor(colorLiteralRed: 31/255, green: 75/255, blue: 164/255, alpha: 1)
let kLoginButtonTintColor = UIColor.white
let kLoginButtonCornerRadius: CGFloat = 13.0
var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

let kTwitterLoginButtonBackgroundColor = UIColor(colorLiteralRed: 85/255, green: 172/255, blue: 239/255, alpha: 1)
let kTwitterLoginButtonTintColor = UIColor.white
let kTwitterLoginButtonCornerRadius: CGFloat = 13.0

let kFacebookLoginButtonBackgroundColor = UIColor(colorLiteralRed: 59/255, green: 89/255, blue: 153/255, alpha: 1)
let kFacebookLoginButtonTintColor = UIColor.white
let kFacebookLoginButtonCornerRadius: CGFloat = 13.0
@IBDesignable
class ATCLoginViewController: UIViewController {

    fileprivate var firebaseEnabled = false
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!

    @IBOutlet weak var UIButtonRegister: UIButton!
    @IBOutlet weak var UIButtonSkip: UIButton!
    @IBOutlet var facebookLoginButton: UIButton!
    @IBOutlet var twitterLoginButton: UIButton!
    fileprivate var loggedInViewController: ATCHostViewController? = nil
    // Facebook login permissions
    // Add extra permissions you need
    // Remove permissions you don't need
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, firebaseEnabled: Bool, loggedInViewController: ATCHostViewController) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.firebaseEnabled = firebaseEnabled
        self.loggedInViewController = loggedInViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLoginButton(loginButton)
        prepareTwitterButton(twitterLoginButton)
        prepareFacebookButton(facebookLoginButton)
        prepareUITextField(usernameTextField)
        prepareUITextField(passwordTextField)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    fileprivate func prepareLoginButton(_ button: UIButton) {
        button.backgroundColor = kLoginButtonBackgroundColor
        button.layer.cornerRadius = kLoginButtonCornerRadius
        button.tintColor = kLoginButtonTintColor
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        UIButtonSkip.addTarget(self, action: #selector(didTapSKipButton), for: .touchUpInside)
        UIButtonRegister.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
    }
    @objc
    fileprivate func didTapRegisterButton(_ sender: LoginButton) {
        let ecommerceRegisterVC = StoryboardEntityProvider().get_view_and_layout(view:"UserRegister",controller:"UserRegister")
        self.present(ecommerceRegisterVC, animated: true, completion: nil)
        
        
    }
    
    
    fileprivate func prepareTwitterButton(_ button: UIButton) {
        button.backgroundColor = kTwitterLoginButtonBackgroundColor
        button.layer.cornerRadius = kTwitterLoginButtonCornerRadius
        button.tintColor = kTwitterLoginButtonTintColor
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        button.addTarget(self, action: #selector(didTapTwitterLoginButton), for: .touchUpInside)
    }

    fileprivate func prepareFacebookButton(_ button: UIButton) {
        button.backgroundColor = kFacebookLoginButtonBackgroundColor
        button.layer.cornerRadius = kFacebookLoginButtonCornerRadius
        button.tintColor = kFacebookLoginButtonTintColor
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        button.addTarget(self, action: #selector(didTapFacebookLoginButton), for: .touchUpInside)
    }

    fileprivate func prepareUITextField(_ textField: UITextField) {
        
    }

    @objc
    fileprivate func didTapLoginButton(_ sender: LoginButton) {
        // Regular login attempt. Add the code to handle the login by email and password.
        guard let email = usernameTextField.text, let pass = passwordTextField.text else {
            // It should never get here
            return
        }
        if (firebaseEnabled) {
            //ATCFirebaseLoginManager.signIn(email: email, pass: pass, completionBlock: self.didCompleteLogin)
        } else {
            didLogin(user_name: email, password: pass)
        }
    }
    
    
    @objc
    fileprivate func didTapSKipButton(_ sender: LoginButton) {
        guard let loggedInViewController = loggedInViewController else { return }
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    @objc
    fileprivate func didTapFacebookLoginButton(_ sender: UIButton) {
        // Facebook login attempt
        LoginManager().logIn(readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }

    @objc
    fileprivate func didTapTwitterLoginButton(_ sender: UIButton) {
        // Twitter login attempt
        Twitter.sharedInstance().logIn(completion: { session, error in
            if let session = session {
                // Successful log in with Twitter
                if (self.firebaseEnabled) {
                    let credential = FIRTwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                    //ATCFirebaseLoginManager.login(credential: credential, completionBlock: self.didCompleteLogin)
                } else {
                    //self.didLogin(firstName: "@" + session.userName)
                }
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
    }

    fileprivate func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }

    fileprivate func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = ATCFacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let firstName = facebookUser?.firstName,
                    let lastName = facebookUser?.lastName,
                    let email = facebookUser?.email {
                    if (self.firebaseEnabled) {
                        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                        //ATCFirebaseLoginManager.login(credential: credential, completionBlock: self.didCompleteLogin)
                    } else {
                        self.didLogin()
                    }
                }
            })
        }
    }

    fileprivate func didLogin(user_name: String = "", password: String = "") {
        
        //let user = ATCUser(firstName: firstName, lastName: lastName, avatarURL: avatarURL)
        //self.didCompleteLogin(user: user)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = AppConfiguration.root_url+"api_task?task=user.login&username="+user_name+"&password="+password
        print(url)
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let requestAPI = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if (error != nil) {
                print(error!.localizedDescription) // On indique dans la console ou est le problème dans la requête
            } else {
                if let content = data {
                    DispatchQueue.main.async {
                        do {
                            //array
                            let response = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            let result:String=response["result"] as! String
                            if(result.elementsEqual("success")==true){
                                let data_user:[String:AnyObject]=response["data"] as! [String:AnyObject]
                                let id:String=data_user["_id"] as! String
                                if(!id.isEmpty)
                                {
                                    let preferentces=UserDefaults.standard
                                    preferentces.set(self.json(from:data_user as Any), forKey: "user")
                                    self.didCompleteLogin()
                                }else{
                                    let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập không thành công", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                    
                                }
                            }else{
                                let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập không thành công", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                            
                      } catch {
                        let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập không thành công", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        }
                    }
                }
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode devrait être de 200, mais il est de \(httpStatus.statusCode)")
                print("réponse = \(response)") // On affiche dans la console si le serveur ne nous renvoit pas un code de 200 qui est le code normal
            }
            
            
            if error == nil {
                // Ce que vous voulez faire.
            }
        }
        requestAPI.resume()
        
        
        
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    fileprivate func didCompleteLogin() {
        guard let loggedInViewController = loggedInViewController else { return }
        self.present(loggedInViewController, animated: true, completion: nil)
        
        
        
       
    }
}
