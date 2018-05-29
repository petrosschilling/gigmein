//
//  JobPostCell.swift
//  GigMeIn
//
//  Created by Petros Schilling on 8/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class JobPostCell: UITableViewCell {

    @IBOutlet weak var lblJobPostTitle: UILabel!
    
    @IBOutlet weak var lblDaysLeft: UILabel!
    
    @IBOutlet weak var lblJobApplicants: UILabel!
    
    
    func setJobPost(jobPost: JobPost){
        self.lblJobPostTitle.text = jobPost.title
        self.lblJobApplicants.text = jobPost.numberOfApplications.description + " applicants"
        let formater = DateFormatter.init(withFormat: "dd/MM/yyyy", locale: Locale.current.languageCode!)
        self.lblDaysLeft.text = "due at " + formater.string(from: jobPost.dueDate)
    }
}
