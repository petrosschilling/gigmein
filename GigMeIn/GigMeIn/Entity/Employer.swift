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
    
    init(email: String, address: Address, phone: String, abn: String, type: UserType, businessName: String) {
        self.businessName = businessName
        super.init(email: email, address: address, phone: phone, abn: abn, type: .EMPLOYER)
    }
    
    init(uid: String, email: String, address: Address, phone: String, abn: String, type: UserType, businessName: String) {
        self.businessName = businessName
        super.init(uid: uid, email: email, address: address, phone: phone, abn: abn, type: .EMPLOYER)
    }
    
    init(uid: String, dateCreated: Date, email: String, address: Address, phone: String, abn: String, type: UserType, businessName: String) {
        self.businessName = businessName
        super.init(uid: uid, dateCreated: dateCreated, email: email, address: address, phone: phone, abn: abn, type: .EMPLOYER)
    }

}
