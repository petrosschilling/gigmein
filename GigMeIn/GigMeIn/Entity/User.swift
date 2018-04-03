//
//  User.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class User: Entity{
    
    var email: String
    var password: String
    //var name: String
    //var surname: String
    var address: Address
    //var dob: Date
    var phone: String
    var abn: String
    var type: UserType
    
    init(email: String, password: String, address: Address, phone: String, abn: String, type: UserType){
        self.email = email
        self.password = password
        self.address = address
        self.phone = phone
        self.abn = abn
        self.type = type
        super.init()
    }
    
    init(id: Int, email: String, password: String, address: Address, phone: String, abn: String, type: UserType){
        self.email = email
        self.password = password
        self.address = address
        self.phone = phone
        self.abn = abn
        self.type = type
        super.init(id: id)
    }
    
    init(id: Int, dateCreated: Date, email: String, password: String, address: Address, phone: String, abn: String, type: UserType){
        self.email = email
        self.password = password
        self.address = address
        self.phone = phone
        self.abn = abn
        self.type = type
        super.init(id: id, dateCreated: dateCreated)
    }
    
    

    

}
