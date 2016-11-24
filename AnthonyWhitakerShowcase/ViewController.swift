//
//  ViewController.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/23/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        facebookLogin.delegate = self
        
        if FBSDKAccessToken.current() != nil {
            print("User logged in to Facebook already")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

extension ViewController : FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("LOGGED INTO FACEBOOK")
        
        print(FBSDKAccessToken.current() == nil)
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
        }
    }
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}

