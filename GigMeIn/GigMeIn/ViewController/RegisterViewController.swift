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
    
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registerDetailViewController = segue.destination as? RegisterDetailViewController {
            registerDetailViewController.modelController = self.modelController
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterToLoginSegue", sender: self)
    }
    
    @IBAction func btnNextPressed(_ sender: UIButton) {
    
        if(!emailIsValid()){
            //TODO show validation message
            return
        }
        if(!passwordIsValid()){
            //TODO show validation message
            return
        }
        
        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (user, error) in
            
            if(error != nil){
                print(error!.localizedDescription)
                return
            }
            
            if(user != nil){
                
                if let userEmail = user?.email{
                    print(userEmail)
                    self.modelController.user.email = userEmail
                    self.modelController.user.uid = (user?.uid)!
                    self.modelController.user.dateCreated = Date.init()
                    self.performSegue(withIdentifier: "RegisterToRegisterDetailSegue", sender: (Any).self)
                }else{
                    print("Email is nil, probleeeeem!!!!")
                }
                
                
            }
        }
    }
    
    func emailIsValid() -> Bool{
        return txtEmail.hasText
    }
    
    func passwordIsValid() -> Bool{
        return txtPassword.hasText
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
