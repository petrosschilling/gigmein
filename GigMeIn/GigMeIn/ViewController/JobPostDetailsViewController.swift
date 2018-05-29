//
//  JobPostDetailsViewController.swift
//  GigMeIn
//
//  Created by Hugo Santos on 29/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class JobPostDetailsViewController: UIViewController {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPayRate: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var jobPost: JobPost! //Add by dependency injection
    var mc: ModelController! //Add by dependency injection
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindJobDetails()
        
    }
    
    func bindJobDetails(){
        if let jp = self.jobPost{
            self.lblTitle.text = jp.title
            self.lblPayRate.text = jp.rate.description + "/h"
            self.lblAddress.text = jp.address?.fullAddress()
            self.lblDescription.text = jp.desc
            if(self.mc.appliedJobIds[jobPost.uid] == true){
                self.lblContactName.text = jp.employer?.fullName()
                self.lblPhone.text = jp.employer?.phone
                self.lblEmail.text = jp.employer?.email
            }else{
                self.lblContactName.text = "not available"
                self.lblPhone.text = "not available"
                self.lblEmail.text = "not available"
            }
        }
    }
}
