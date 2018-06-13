//
//  LoadingViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 13/6/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit
import FirebaseAuth
import PromiseKit

class LoadingViewController: UIViewController {

    let employeeSegueID = "EmployeeSegue"
    let employerSegueID = "EmployerSegue"
    let loadingToLoginSegueID = "LoadingToLoginSegue"
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            
            if let user = user{
                firstly{
                    self.mc.loadUserProfile(user: user)
                }.done{ u in
                    self.mc.user = u
                    if(u.type == UserType.EMPLOYER){
                        self.performSegue(withIdentifier: self.employerSegueID, sender: self)
                    }else if(u.type == UserType.EMPLOYEE){
                        self.performSegue(withIdentifier: self.employeeSegueID, sender: self)
                    }
                }.catch{ error in
                    //self.mc.logoutUser()
                }
            }else{
                self.performSegue(withIdentifier: self.loadingToLoginSegueID, sender: self)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController{
            if let jobsPostedVC =  nc.childViewControllers[0] as? JobsPostedViewController{
                jobsPostedVC.mc = self.mc
            } else if let employeeMainVC =  nc.childViewControllers[0] as? EmployeeMainViewController{
                employeeMainVC.mc = self.mc
            }
        }else if let loginVC = segue.destination as? LoginViewController{
            loginVC.mc = self.mc
        }
    }

}
