//
//  Employee.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
class Employee: User {
    
    var name: String
    var surname: String
    var dob: Date
    var tfn: String
    
    init(email: String, password: String, address: Address, phone: String, abn: String, type: UserType, name: String, surname: String, dob: Date, tfn: String) {
        self.name = name
        self.surname = surname
        self.dob = dob
        self.tfn = tfn
        super.init(email: email, password: password, address: address, phone: phone, abn: abn, type: .EMPLOYEE)
    }
    
    init(id: Int, email: String, password: String, address: Address, phone: String, abn: String, type: UserType, name: String, surname: String, dob: Date, tfn: String) {
        self.name = name
        self.surname = surname
        self.dob = dob
        self.tfn = tfn
        super.init(id: id, email: email, password: password, address: address, phone: phone, abn: abn, type: .EMPLOYEE)
    }
    
    init(id: Int, dateCreated: Date, email: String, password: String, address: Address, phone: String, abn: String, type: UserType, name: String, surname: String, dob: Date, tfn: String) {
        self.name = name
        self.surname = surname
        self.dob = dob
        self.tfn = tfn
        super.init(id: id, dateCreated: dateCreated, email: email, password: password, address: address, phone: phone, abn: abn, type: .EMPLOYEE)
    }
    
}
