//
//  JobPostDetailsViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 29/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class JobPostDetailsViewController: UIViewController {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPayRate: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    let notAvailableMessage = "Not available"
    
    var jobPost: JobPost!
    var mc: ModelController!
    
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
            
            let formater = DateFormatter.init(withFormat: "dd/MM/yyyy", locale: Locale.current.languageCode!)
            self.lblDueDate.text = "Job expires at " + formater.string(from: jobPost.dueDate)
            if(self.mc.appliedJobIds[jobPost.uid] == true){
                self.lblContactName.text = jp.employer?.firstName
                self.lblPhone.text = jp.employer?.phone
                self.lblEmail.text = jp.employer?.email
            }else{
                self.lblContactName.text = self.notAvailableMessage
                self.lblPhone.text = self.notAvailableMessage
                self.lblEmail.text = self.notAvailableMessage
            }
        }
    }
}
