//
//  ViewController.swift
//  MySocial
//
//  Created by Rennie on 2016/09/26.
//  Copyright © 2016 Rennie. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
    
        let facebookLogin = FBSDKLoginManager()
    
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("RENZ: Unable to auth with FB - \(error)")
            } else if result?.isCancelled == true {
                print("RENZ: user cancelled FB Auth")
            } else {
                print ("RENZ: successfully auth with FB")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print("RENZ - unable to auth with Firebase - \(error)")
            } else {
                print("RENZ- Successfully auth with Firebase")
            }
                
        })
        
    }

    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error == nil {
                    print("RENZ: User Auth with Firebase - \(error)")
                } else {
                    FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user,error) in
                        if error == nil {
                            print("RENZ: User Auth with Firebase using email- \(error)")
                        } else {
                            print("RENZ: Successful Auth with FB using email")
                        }
                    })
                }
        
            })
        }
    }
  }
