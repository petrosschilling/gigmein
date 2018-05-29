//
//  ApplicantProfileViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class ApplicantProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSex: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    //Vars needed by dependency injection
    var mc: ModelController!
    var user: User!
    var job: JobPost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = DateFormatter.init(withFormat: "dd/MM/yyyy", locale: Locale.current.languageCode!)
        
        if let u = self.user{
            self.lblEmail.text = u.email
            self.lblSex.text = ""
            self.lblPhone.text = u.phone
            if let dob = u.dob{
                self.lblDOB.text = format.string(from: dob)
            }
            self.lblAddress.text = u.address.fullAddress()
            self.lblName.text = u.fullName()
        }else{
            print("Error: user not set in ApplicantProfileViewController")
        }
    }

    @IBAction func btnAcceptApplicationClick(_ sender: Any) {
        self.mc.acceptJobApplication(user: self.user, job:self.job)
        
        
    }
}
