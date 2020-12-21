//
//  LoginView.swift
//  Xib-Demo
//
//  Created by Alex Paul on 2/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class LoginView: UIView {
  
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var accountMessageLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    //commonInit()
  }
  
  private func commonInit() {
    // load the nib file
    Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
}
