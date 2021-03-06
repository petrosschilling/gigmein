//
//  EmployeeJobPostCell.swift
//  GigMeIn
//
//  Created by Petros Schilling on 10/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit

class EmployeeJobPostCell: UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    
    func setJobPost(jobPost: JobPost){
        
        self.lblTitle.text = jobPost.title
        self.lblDescription.text = jobPost.desc
        self.lblAddress.text = jobPost.address?.fullAddress()
        
        let formater = DateFormatter.init(withFormat: "dd/MM/yyyy", locale: Locale.current.languageCode!)
        self.lblDueDate.text = "due at " + formater.string(from: jobPost.dueDate)
        
        self.lblCash.text = jobPost.rate.description
        
    }
}
