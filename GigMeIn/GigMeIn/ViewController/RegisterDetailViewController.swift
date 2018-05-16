//
//  RegisterDetailViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 30/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterDetailViewController :UIViewController{
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var modelController: ModelController!
    var userTypeArray = [UserType.EMPLOYEE, UserType.EMPLOYER]
    var dbRef: DatabaseReference! = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLookingJobClick(_ sender: UIButton) {
        if(!isNameValid()){
            return
        }
        if (!isPhoneValid()){
            return
        }
        self.setUserData(userType: UserType.EMPLOYEE)
        self.saveUserDetails()
        if let user = Auth.auth().currentUser{
            self.modelController.loadUserProfile(user: user).cauterize()
        }
    }
    
    @IBAction func btnLookingForPeopleClick(_ sender: UIButton) {
        if(!isNameValid()){
            return
        }
        if (!isPhoneValid()){
            return
        }
        self.setUserData(userType: UserType.EMPLOYER)
        self.saveUserDetails()
        if let user = Auth.auth().currentUser{
            self.modelController.loadUserProfile(user: user).cauterize()
        }
    }
    
    func saveUserDetails(){
        self.updateUserDisplayNameInFirebase()
        let uid = self.modelController.user.uid
        let userJSON = self.modelController.user.toJSON()
        self.dbRef.child("users").child(uid).setValue(userJSON)
    }
    
    func setUserData(userType: UserType){
        self.modelController.user.firstName = self.txtFirstName.text
        self.modelController.user.phone = self.txtPhone.text
        self.modelController.user.type = userType
        self.modelController.user.uid = (Auth.auth().currentUser?.uid)!;
    }
    
    func updateUserDisplayNameInFirebase(){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.modelController.user.firstName
        changeRequest?.commitChanges { (error) in
            print("An error has occurred while trying to update users displayName")
        }
    }
    
    func isNameValid() -> Bool {
        //TODO
        return true
    }
    
    func isPhoneValid() -> Bool {
        //TODO
        return true
    }
    
}
