//
//  EditJobPostViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 11/6/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit

class EditJobPostViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtRate: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var dateDue: UIDatePicker!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtState: UITextField!
    
    var mc: ModelController!
    var postToEdit: JobPost!
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initToolBar()
        self.bindJobPostDataToView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditJobPostViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditJobPostViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func bindJobPostDataToView(){
        self.txtTitle.text = self.postToEdit.title
        self.txtDescription.text = self.postToEdit.desc
        self.dateDue.date = self.postToEdit.dueDate
        //self.dateDue.setDate(self.postToEdit.dueDate, animated: false)
        self.txtRate.text = self.postToEdit.rate.description
        self.txtUnit.text = self.postToEdit.address?.unit
        self.txtNumber.text = self.postToEdit.address?.streetNumber
        self.txtStreet.text = self.postToEdit.address?.streetName
        self.txtCity.text = self.postToEdit.address?.city
        self.txtPostCode.text = self.postToEdit.address?.postcode
        self.txtState.text = self.postToEdit.address?.state
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        if(!self.runValidations()){
            return
        }
        
        self.postToEdit.address = Address.init()
        
        self.postToEdit.employer = self.mc.user
        self.postToEdit.title = txtTitle.text!
        self.postToEdit.desc = txtDescription.text
        self.postToEdit.dueDate = dateDue.date
        if let rate = self.txtRate.text{
            self.postToEdit.rate = Double(rate)!
        }
        self.postToEdit.address?.unit = txtUnit.text!
        self.postToEdit.address?.streetNumber = self.txtNumber.text!
        self.postToEdit.address?.streetName = self.txtStreet.text!
        self.postToEdit.address?.city = self.txtCity.text!
        self.postToEdit.address?.state = self.txtState.text!
        self.postToEdit.address?.postcode = self.txtPostCode.text!
        
        self.mc.updateJobPost(jobPost: postToEdit)
        
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
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
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
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(EditJobPostViewController.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.txtUnit.inputAccessoryView = toolbar
        self.txtNumber.inputAccessoryView = toolbar
        self.txtRate.inputAccessoryView = toolbar
        self.txtDescription.inputAccessoryView = toolbar
        self.txtPostCode.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
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
        if(self.dateDue.date <= Date()){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "The date cannot be in the past", vc: self)
            return false
        }
        return true
    }
    
    func isPaymentRateValid() -> Bool{
        if(self.txtRate.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Payment rate", vc: self)
            return false
        }
        return true
    }
    
    func isUnitNumberValid() -> Bool{
        if(self.txtUnit.text?.count == 0){
            AlertUtils.showAlertWithOk(title: "Oops!", message: "You must fill the Unit for the address", vc: self)
            return false
        }
        return true
    }
    
    func isStreetNumberValid() -> Bool{
        if(self.txtNumber.text?.count == 0){
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
