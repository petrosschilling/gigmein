//
//  RegisterDetailViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 30/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import FirebaseAuth

class RegisterDetailViewController :UIViewController{
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var switchTypeOfUser: UISwitch!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblStaff: UILabel!
    
    let userTypeArray = [UserType.EMPLOYEE, UserType.EMPLOYER]
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.lblStaff.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController{
            if let jobsPostedVC =  nc.childViewControllers[0] as? JobsPostedViewController{
                jobsPostedVC.mc = self.mc
            } else if let employeeMainVC =  nc.childViewControllers[0] as? EmployeeMainViewController{
                employeeMainVC.mc = self.mc
            }
        }
    }
    
    @IBAction func switchUserTypeStateChanged(_ sender: Any) {
        self.lblStaff.isEnabled = self.switchTypeOfUser.isOn
        self.lblWork.isEnabled = !self.switchTypeOfUser.isOn
    }
    
    @IBAction func btnNextPressed(_ sender: Any) {
        if(!isNameValid()){
            return
        }
        if(!isSurnameValid()){
            return
        }
        if (!isPhoneValid()){
            return
        }
        
        if(self.switchTypeOfUser.isOn){
            self.setUserData(userType: UserType.EMPLOYER)
        }else{
            self.setUserData(userType: UserType.EMPLOYEE)
        }
        self.mc.saveUserDetails()
        if let user = self.mc.getFirebaseUser(){
            firstly{
                self.mc.loadUserProfile(user: user)
            }.done{ user in
                if(user.type == UserType.EMPLOYER){
                    self.performSegue(withIdentifier: "RegisterToEmployerSegue", sender: self)
                }else if(user.type == UserType.EMPLOYEE){
                    self.performSegue(withIdentifier: "RegisterToEmployeeSegue", sender: self)
                }
            }.cauterize()
        }
    }
    
    func setUserData(userType: UserType){
        self.mc.user.firstName = self.txtFirstName.text!
        self.mc.user.surname = self.txtLastName.text!
        self.mc.user.phone = self.txtPhone.text
        self.mc.user.type = userType
        self.mc.user.uid = (Auth.auth().currentUser?.uid)!;
    }
    
    func isNameValid() -> Bool {
        let firstName = Sanitizer.trim(text: self.txtFirstName.text!)
        if(firstName.count == 0){
            AlertUtils.showAlertWithOk(title: "Name is invalid", message: "Name cannot be empty", vc: self)
            return false
        }else if(firstName.count > 40){
            AlertUtils.showAlertWithOk(title: "Name is invalid", message: "Name is too long", vc: self)
            return false
        }
        return true
    }
    
    func isSurnameValid() -> Bool{
        let surname = Sanitizer.trim(text: self.txtLastName.text!)
        if(surname.count == 0){
            AlertUtils.showAlertWithOk(title: "Surname is invalid", message: "Surname cannot be empty", vc: self)
            return false
        }else if(surname.count > 40){
            AlertUtils.showAlertWithOk(title: "Surname is invalid", message: "Surname is too long", vc: self)
            return false
        }
        return true
    }
    
    func isPhoneValid() -> Bool {
        let phone = Sanitizer.trim(text: self.txtPhone.text!)
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phone))){
            AlertUtils.showAlertWithOk(title: "Phone is invalid", message: "Phone contains non-numeric characters", vc: self)
            return false
        }else if(phone.count < 10 || phone.count > 12){
            AlertUtils.showAlertWithOk(title: "Phone is invalid", message: "Phone must have between 10 and 12 digits", vc: self)
            return false
        }
        return true
    }
    
}
