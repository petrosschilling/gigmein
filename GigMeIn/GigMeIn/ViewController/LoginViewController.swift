//
//  LoginViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController :UIViewController{
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if let user = user{
                self.mc.loadUserProfile(user: user, redirectionHandler: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registerViewController = segue.destination as? RegisterViewController {
            registerViewController.modelController = self.mc
        }
    }

    @IBAction func btnRegisterPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToRegisterSegue", sender: self)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if(error != nil){
                print(error!.localizedDescription)
            }
            
            if(user != nil){
                print("Login successful! :)")
                self.mc.loadUserProfile(user: user!, redirectionHandler: self)
            }
        }
    }
    
}
