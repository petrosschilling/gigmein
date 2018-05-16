//
//  JobApplication.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import ObjectMapper

class JobApplication: Entity{
    
    var applicant: User?
    var jobPost: JobPost?
    var status: JobApplicationStatus! = .PENDING
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    
    
}
