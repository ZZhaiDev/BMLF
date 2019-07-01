//
//  ZJLoginController.swift
//  BMLife
//
//  Created by Zijia Zhai on 7/1/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

var isLoggedIn = false

class ZJLoginController: UIViewController {
    
    fileprivate let fbLoginButton = FBLoginButton()
    

    override func viewDidLoad() {
        // Add a custom login button to your app
        super.viewDidLoad()
        fbLoginButton.backgroundColor = UIColor.darkGray
        fbLoginButton.frame = CGRect(x: 0, y: 0, width: 250, height: 28)
        fbLoginButton.center = self.view.center
        fbLoginButton.setTitle("My Login Button", for: .normal)
        fbLoginButton.delegate = self
        
        // Handle clicks on the button
        // Add the button to the view
        view.addSubview(fbLoginButton)  
    }
}


extension ZJLoginController: LoginButtonDelegate {
    
    fileprivate func showAlert(withTitle title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            showAlert(withTitle: "Error", message: "Something went wrong. Please try again!")
        } else if result!.isCancelled{
            showAlert(withTitle: "Cancelled", message: "Successfully Cancelled")
        } else {
            let params = ["fields": "email, first_name, last_name, picture"]
            GraphRequest(graphPath: "me", parameters: params).start(completionHandler: { connection, result, error in
                ZJPrint(result)
            })
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        showAlert(withTitle: "Success", message: "Successfully Logged out")
    }
}
