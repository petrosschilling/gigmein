//
//  CreateJobPostViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 1/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class CreateJobPostViewController: UIViewController{
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var dtDueDate: UIDatePicker!
    @IBOutlet weak var segPaymentType: UISegmentedControl!
    @IBOutlet weak var txtPaymentRate: UITextField!
    @IBOutlet weak var txtUnitNumber: UITextField!
    @IBOutlet weak var txtStreetNumber: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtState: UITextField!
    
    var modelController: ModelController!
    let segPaymentTypeItems = [PaymentType.CASH.rawValue, PaymentType.ABN.rawValue, PaymentType.TFN.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segPaymentType.removeAllSegments();
        segPaymentType.insertSegment(withTitle: PaymentType.CASH.rawValue, at: 0, animated: true)
        segPaymentType.insertSegment(withTitle: PaymentType.ABN.rawValue, at: 1, animated: true)
        segPaymentType.insertSegment(withTitle: PaymentType.TFN.rawValue, at: 2, animated: true)
        segPaymentType.selectedSegmentIndex = 0;
    }
    
    @IBAction func btnPostJobClick(_ sender: UIButton) {
    
        //TODO validate all fields
        
        let jobPost: JobPost = JobPost()
        jobPost.address = Address.init()
        
        jobPost.employer = modelController.user
        jobPost.title = txtTitle.text!
        jobPost.description = txtDescription.text
        jobPost.dueDate = dtDueDate.date
        jobPost.dateCreated = Date.init()
        if let rate = txtPaymentRate.text{
            jobPost.rate = Double(rate)!
        }
        if let PTraw = segPaymentType.titleForSegment(at: segPaymentType.selectedSegmentIndex){
            jobPost.paymentType = PaymentType(rawValue: PTraw)
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
    
    func isTitleValid() -> Bool{
        //TODO
        return true
    }
    
    func isDescriptionValid() -> Bool{
        //TODO
        return true
    }
    
    func isDueDateValid() -> Bool{
        //TODO
        return true
    }
    
    func isPaymentRateValid() -> Bool{
        //TODO
        return true
    }
    
    func isUnitNumberValid() -> Bool{
        //TODO
        return true
    }
    
    func isStreetNumberValid() -> Bool{
        //TODO
        return true
    }
    
    func isStreetValid() -> Bool{
        //TODO
        return true
    }
    
    func isCityValid() -> Bool{
        //TODO
        return true
    }
    
    func isPostcodeValid() -> Bool{
        //TODO
        return true
    }
    
    func isStateValid() -> Bool{
        //TODO
        return true
    }
    
}
