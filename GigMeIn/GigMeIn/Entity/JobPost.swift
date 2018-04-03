//
//  JobPost.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class JobPost: Entity{
    
    var employer: Employer
    var address: Address
    var rate: Double
    var paymentType: PaymentType
    var description: String
    var dueDate : Date
    
    init(employer: Employer, address: Address, rate: Double, paymentType: PaymentType, description: String, dueDate: Date) {
        self.employer = employer
        self.address = address
        self.rate = rate
        self.paymentType = paymentType
        self.description = description
        self.dueDate = dueDate
        super.init()
    }
    
    init(id: Int, employer: Employer, address: Address, rate: Double, paymentType: PaymentType, description: String, dueDate: Date) {
        self.employer = employer
        self.address = address
        self.rate = rate
        self.paymentType = paymentType
        self.description = description
        self.dueDate = dueDate
        super.init(id: id)
    }
    
    init(id: Int, dateCreated: Date, employer: Employer, address: Address, rate: Double, paymentType: PaymentType, description: String, dueDate: Date) {
        self.employer = employer
        self.address = address
        self.rate = rate
        self.paymentType = paymentType
        self.description = description
        self.dueDate = dueDate
        super.init(id: id, dateCreated: dateCreated)
    }
    
}
