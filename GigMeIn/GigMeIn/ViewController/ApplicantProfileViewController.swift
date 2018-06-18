//
//  ApplicantProfileViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class ApplicantProfileViewController: UIViewController {
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    //Vars needed by dependency injection
    var mc: ModelController!
    var user: User!
    var job: JobPost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let u = self.user{
            self.lblEmail.text = u.email
            self.lblPhone.text = u.phone
            self.lblName.text = u.fullName()
        }else{
            print("Error: user not set in ApplicantProfileViewController")
        }
    }
    @IBAction func btnReject(_ sender: Any) {
        self.mc.rejectJobApplication(user: self.user, job:self.job)
    }
    
    @IBAction func btnAcceptApplicationClick(_ sender: Any) {
        self.mc.acceptJobApplication(user: self.user, job:self.job)
    }
}
