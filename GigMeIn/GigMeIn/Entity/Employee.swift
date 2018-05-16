//
//  Employee.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
class Employee: User {
    
    var dob: Date
    var tfn: String
    
    init(email: String, address: Address, phone: String, abn: String, type: UserType, dob: Date, tfn: String) {
        self.dob = dob
        self.tfn = tfn
        super.init(email: email, address: address, phone: phone, abn: abn, type: .EMPLOYEE)
    }
    
    init(uid: String, email: String, password: String, address: Address, phone: String, abn: String, type: UserType, dob: Date, tfn: String) {
        self.dob = dob
        self.tfn = tfn
        super.init(uid: uid, email: email, address: address, phone: phone, abn: abn, type: .EMPLOYEE)
    }
    
    init(uid: String, dateCreated: Date, email: String, address: Address, phone: String, abn: String, type: UserType, dob: Date, tfn: String) {
        self.dob = dob
        self.tfn = tfn
        super.init(uid: uid, dateCreated: dateCreated, email: email, address: address, phone: phone, abn: abn, type: .EMPLOYEE)
    }
    
}
