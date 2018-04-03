//
//  Employer.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class Employer: User {
    
    var businessName: String
    
    init(email: String, password: String, address: Address, phone: String, abn: String, type: UserType, businessName: String) {
        self.businessName = businessName
        super.init(email: email, password: password, address: address, phone: phone, abn: abn, type: .EMPLOYER)
    }
    
    init(id: Int, email: String, password: String, address: Address, phone: String, abn: String, type: UserType, businessName: String) {
        self.businessName = businessName
        super.init(id: id, email: email, password: password, address: address, phone: phone, abn: abn, type: .EMPLOYER)
    }
    
    init(id: Int, dateCreated: Date, email: String, password: String, address: Address, phone: String, abn: String, type: UserType, businessName: String) {
        self.businessName = businessName
        super.init(id: id, dateCreated: dateCreated, email: email, password: password, address: address, phone: phone, abn: abn, type: .EMPLOYER)
    }

}
