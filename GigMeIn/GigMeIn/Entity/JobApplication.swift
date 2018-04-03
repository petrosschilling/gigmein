//
//  JobApplication.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class JobApplication: Entity{
    
    var applicant: Employee
    var jobPost: JobPost
    var status: JobApplicationStatus = .PENDING
    
    init(applicant: Employee, jobPost: JobPost) {
        self.applicant = applicant
        self.jobPost = jobPost
        super.init()
    }
    
    init(id: Int, applicant: Employee, jobPost: JobPost, status: JobApplicationStatus) {
        self.applicant = applicant
        self.jobPost = jobPost
        self.status = status
        super.init(id: id)
    }
    
    init(id: Int, dateCreated: Date, applicant: Employee, jobPost: JobPost, status: JobApplicationStatus) {
        self.applicant = applicant
        self.jobPost = jobPost
        self.status = status
        super.init(id: id, dateCreated: dateCreated)
    }
    
    
}
