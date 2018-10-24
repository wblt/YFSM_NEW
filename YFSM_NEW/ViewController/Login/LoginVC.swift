//
//  LoginVC.swift
//  DigitalCampus
//
//  Created by luo on 16/4/23.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    @IBOutlet weak var _numberTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!
    @IBOutlet weak var _loginButton: UIButton!
    
    fileprivate var isCanLogin = (false, false) {
        didSet {
            changeLoginButton(isCanLogin == (true, true))
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.isHidden = true
        
        _numberTextField.addTarget(self, action: #selector(LoginVC.textChange(_:)), for: .editingChanged)
        _passwordTextField.addTarget(self, action: #selector(LoginVC.textChange(_:)), for: .editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - event、response
extension LoginVC {
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        BFunction.shared.showLoading()
        isCanLogin.0 = false
        
        BaseRequest.shared.userLogin(_numberTextField.text!, password: _passwordTextField.text!, completion: { [weak self] (model) in
            
            self?.isCanLogin.0 = true
            BFunction.shared.hideLoadingMessage()
            
            if let _ = model {
                
                let isF = AccountManager.shared.isFirstLogin
                
                if isF != nil && isF! {
                    
                    AccountManager.shared.isFirstLogin = false
                    self?.toMainVC()
                } else {
                    
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }, errorRequest: { [weak self] (response, errorObject) -> Void in
            
            self?.isCanLogin.0 = true
        }, failedRequest: { [weak self] (response, error) -> Void in
            
            self?.isCanLogin.0 = true
        })
    }
        
    @IBAction func userAgreementAction(_ sender: UIButton) {
        
        let url = BaseRequest.shared.apiURL + "/dobyschool/readMe.htm"
        NavigationManager.pushToWebView(form: self, url: url, title: "用户协议")
    }
    
    fileprivate func toMainVC() {
       /* let vc = StoryboardManager.storyboard(with: "Main")("MainTabBar") as! MainTabBar
        let window = UIApplication.shared.delegate?.window
        
        UIView.transition(with: window!!, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.delegate!.window!!.rootViewController = vc
            UIView.setAnimationsEnabled(oldState)
            
            }, completion: nil)*/
    }
    
    @objc func textChange(_ sender: UITextField) {
        
        if let t = _numberTextField.text , !t.isEmpty {
            isCanLogin.0 = true
        }else{
            isCanLogin.0 = false
        }
        
        if let t = _passwordTextField.text , !t.isEmpty {
            isCanLogin.1 = true
        }else{
            isCanLogin.1 = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

// MARK: - getters、setters
extension LoginVC {
    
    fileprivate func changeLoginButton(_ isEnabled: Bool) {
        
        _loginButton.isEnabled = isEnabled
        if isEnabled {
            _loginButton.backgroundColor = UIColorHex("#2092E0")
        } else {
            _loginButton.backgroundColor = UIColorHex("#ABABAB")
        }
    }
}
