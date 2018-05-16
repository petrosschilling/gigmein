//
//  StoryboardNavigationController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 15/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit

class StoryboardNavigationController{
    
    func goToEmployerStoryBoard(viewRedirectionHandler: UIViewController, mc: ModelController){
        let employerSB = UIStoryboard(name: "Employer", bundle: nil)
        let employerNC = employerSB.instantiateViewController(withIdentifier: "MainEmployerStoryID")
        let employerVC = employerNC.childViewControllers[0] as! JobsPostedViewController
        employerVC.mc = mc
        viewRedirectionHandler.present(employerNC, animated: true, completion: nil)
    }
    
    func goToEmployeeStoryBoard(viewRedirectionHandler: UIViewController, mc: ModelController){
        let employeeSB = UIStoryboard(name: "Employee", bundle: nil)
        let employeeNC = employeeSB.instantiateViewController(withIdentifier: "MainEmployeeStoryID")
        let employeeVC = employeeNC.childViewControllers[0] as! EmployeeMainViewController
        employeeVC.mc = mc
        viewRedirectionHandler.present(employeeNC, animated: true, completion: nil)
    }
    
    func goToLoginStoryboard(viewRedirectionHandler: UIViewController, mc: ModelController){
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = loginSB.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        loginVC.mc = mc
        viewRedirectionHandler.present(loginVC, animated: true, completion: nil)
    }
    
}
