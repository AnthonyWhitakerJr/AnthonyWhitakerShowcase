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

class LogInViewController: UIViewController {
    
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    
    @IBOutlet weak var emailAddressField: MaterialTextField!
    @IBOutlet weak var passwordField: MaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        facebookLogin.delegate = self
        
        if FBSDKAccessToken.current() != nil {
            print("User logged in to Facebook already")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: Segue.loggedIn.rawValue, sender: nil)
        }
    }
    
    @IBAction func emailSignInAttempted(_ sender: UIButton) {
        if let email = emailAddressField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty {
            print("Email: \(email) Password:\(password)")
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error as? NSError {
                    switch error.code {
                    case FIRAuthErrorCode.errorCodeUserNotFound.rawValue:
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if let error = error as? NSError {
                                switch error.code {
                                case FIRAuthErrorCode.errorCodeWeakPassword.rawValue:
                                    self.showErrorAlert(title: "Weak Password", message: "Password should be at least 6 characters.")
                                default:
                                    self.showErrorAlert(title: "Could not create account", message: "Problem creating account. Try something else.")
                                }
                                print(error)
                            }
                            
                            self.signIn(as: user)
                        })
                    case FIRAuthErrorCode.errorCodeInvalidEmail.rawValue:
                        self.showErrorAlert(title: "Invalid Email Format", message: "The email address is badly formatted.")
                    case FIRAuthErrorCode.errorCodeWrongPassword.rawValue:
                        self.showErrorAlert(title: "Wrong Password", message: "That email address is registered with a different password. Try again.")
                    default:
                        print(error)
                    }
                } else {
                    self.signIn(as: user)
                }
            })
            
            
        } else {
            showErrorAlert(title: "Email and Password Required", message: "You must enter an email address and a password.")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func signIn(as user: FIRUser?) {
        UserDefaults.standard.set(user?.uid, forKey: KEY_UID)
        self.performSegue(withIdentifier: Segue.loggedIn.rawValue, sender: nil)
    }
    
}

extension LogInViewController : FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("LOGGED INTO FACEBOOK")
        
        print(FBSDKAccessToken.current() == nil)
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            self.signIn(as: user)
        }
    }
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}

