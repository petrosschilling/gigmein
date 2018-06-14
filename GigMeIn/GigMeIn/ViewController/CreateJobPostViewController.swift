//
//  CreateJobPostViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 1/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit

class CreateJobPostViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var dtDueDate: UIDatePicker!
    @IBOutlet weak var txtPaymentRate: UITextField!
    @IBOutlet weak var txtUnitNumber: UITextField!
    @IBOutlet weak var txtStreetNumber: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtState: UITextField!
    
    var modelController: ModelController!
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initToolBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateJobPostViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateJobPostViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    @IBAction func btnPostJobClick(_ sender: UIButton) {
    
        if(!runValidations()){
            return
        }
        
        let jobPost: JobPost = JobPost()
        jobPost.address = Address.init()
        
        jobPost.employer = modelController.user
        jobPost.title = txtTitle.text!
        jobPost.desc = txtDescription.text
        jobPost.dueDate = dtDueDate.date
        jobPost.dateCreated = Date.init()
        if let rate = txtPaymentRate.text{
            jobPost.rate = Double(rate)!
        }
        jobPost.address?.unit = txtUnitNumber.text!
        jobPost.address?.streetNumber = txtStreetNumber.text!
        jobPost.address?.streetName = txtStreet.text!
        jobPost.address?.city = txtCity.text!
        jobPost.address?.state = txtState.text!
        jobPost.address?.postcode = txtPostCode.text!
        
        self.modelController.postJob(jobPost: jobPost)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Keyboard Control Methods
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyBH = keyboardSize.height
            let vH = self.view!.bounds.height
            let textY = self.activeTextField.frame.origin.y + self.activeTextField.bounds.maxY
            let visibleHeight = vH - keyBH
            if (visibleHeight < textY){
                let yUp = visibleHeight - textY - 4
                self.view.frame.origin.y = yUp // Move view n points upward
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func initToolBar(){
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CreateJobPostViewController.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.txtUnitNumber.inputAccessoryView = toolbar
        self.txtStreetNumber.inputAccessoryView = toolbar
        self.txtPaymentRate.inputAccessoryView = toolbar
        self.txtDescription.inputAccessoryView = toolbar
        self.txtPostCode.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    //MARK: - Validation Methods
    
    func runValidations() -> Bool{
        return isTitleValid() && isDescriptionValid() && isDueDateValid() && isPaymentRateValid() && isUnitNumberValid() && isStreetNumberValid() && isStreetValid() && isCityValid() && isPostcodeValid() && isStateValid()
    }
    
    func isTitleValid() -> Bool{
        if(self.txtTitle.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Title", vc: self)
            return false
        }
        return true
    }
    
    func isDescriptionValid() -> Bool{
        if(self.txtDescription.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Description", vc: self)
            return false
        }
        return true
    }
    
    func isDueDateValid() -> Bool{
        if(self.dtDueDate.date <= Date()){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "The date cannot be in the past", vc: self)
            return false
        }
        return true
    }
    
    func isPaymentRateValid() -> Bool{
        if(self.txtPaymentRate.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Payment rate", vc: self)
            return false
        }
        return true
    }
    
    func isUnitNumberValid() -> Bool{
        if(self.txtUnitNumber.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Unit for the address", vc: self)
            return false
        }
        return true
    }
    
    func isStreetNumberValid() -> Bool{
        if(self.txtStreetNumber.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Street number for the address", vc: self)
            return false
        }
        return true
    }
    
    func isStreetValid() -> Bool{
        if(self.txtStreet.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Street for the address", vc: self)
            return false
        }
        return true
    }
    
    func isCityValid() -> Bool{
        if(self.txtCity.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the City for the address", vc: self)
            return false
        }
        return true
    }
    
    func isPostcodeValid() -> Bool{
        if(self.txtPostCode.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Postcode for the address", vc: self)
            return false
        }
        return true
    }
    
    func isStateValid() -> Bool{
        if(self.txtState.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the State for the address", vc: self)
            return false
        }
        return true
    }
    
}
