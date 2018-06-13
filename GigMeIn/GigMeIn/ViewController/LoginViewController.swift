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
import PromiseKit

class LoginViewController :UIViewController{
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let loginToRegisterSegueID = "LoginToRegisterSegue"
    let loginToEmployeeSegueID = "LoginToEmployeeSegue"
    let loginToEmployerSegueID = "LoginToEmployerSegue"
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController{
            if let jobsPostedVC =  nc.childViewControllers[0] as? JobsPostedViewController{
                jobsPostedVC.mc = self.mc
            } else if let employeeMainVC =  nc.childViewControllers[0] as? EmployeeMainViewController{
                employeeMainVC.mc = self.mc
            }
        }else if let registerViewController = segue.destination as? RegisterViewController {
            registerViewController.mc = self.mc
        }
    }

    @IBAction func btnRegisterPressed(_ sender: UIButton) {
        performSegue(withIdentifier: self.loginToRegisterSegueID, sender: self)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if(!isLoginValid()){
            return
        }
        if(!isPasswordValid()){
            return
        }
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if(error != nil){
                print(error!.localizedDescription)
            }
            
            if(user != nil){
                firstly{
                    self.mc.loadUserProfile(user: user!)
                }.done{ user in
                    if(user.type == UserType.EMPLOYER){
                        self.performSegue(withIdentifier: self.loginToEmployerSegueID, sender: self)
                    }else if(user.type == UserType.EMPLOYEE){
                        self.performSegue(withIdentifier: self.loginToEmployeeSegueID, sender: self)
                    }
                }.cauterize()
                
            }else{
                AlertUtils.showAlertWithOk(title: "Oops!", message: "Couldn't locate a user with these credentials", vc: self)
            }
        }
    }
    
    func isLoginValid() -> Bool{
        if(self.txtEmail.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "Email cannot be empty", vc: self)
            return false
        }
        return true
    }
    
    func isPasswordValid() -> Bool{
        if(self.txtPassword.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "Password cannot be empty", vc: self)
            return false
        }
        return true
    }
    
}
