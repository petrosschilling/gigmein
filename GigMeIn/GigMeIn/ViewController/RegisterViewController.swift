//
//  RegisterViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterViewController :UIViewController{
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let registerToLoginSegueID = "RegisterToLoginSegue"
    let registerToRegisterDetailSegueID = "RegisterToRegisterDetailSegue"
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registerDetailViewController = segue.destination as? RegisterDetailViewController {
            registerDetailViewController.mc = self.mc
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.mc.user = User(email: "")
        performSegue(withIdentifier: self.registerToLoginSegueID, sender: self)
    }
    
    @IBAction func btnNextPressed(_ sender: UIButton) {
    
        if(!isLoginValid()){
            return
        }
        if(!isPasswordValid()){
            return
        }
        
        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (user, error) in
            
            if(error != nil){
                print(error!.localizedDescription)
                AlertUtils.showAlertWithOk(title: "Oops!", message: "Email must be in an email format e.g. aaa@bbb.com", vc: self)
                return
            }
            
            if(user != nil){
                
                if let userEmail = user?.email{
                    print(userEmail)
                    self.mc.user.email = userEmail
                    self.mc.user.uid = (user?.uid)!
                    self.mc.user.dateCreated = Date.init()
                    self.performSegue(withIdentifier: self.registerToRegisterDetailSegueID, sender: self)
                }
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
        if((self.txtPassword.text?.count)! < 6){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "Password must have at least 6 characters", vc: self)
            return false
        }
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
