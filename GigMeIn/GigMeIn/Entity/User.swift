//
//  User.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Entity{
    var email: String!
    var address: Address! //ADD LATER to extension transform it as a JSON object
    var phone: String?
    var abn: String?
    var type: UserType!
    var firstName: String?
    var surname: String?
    
    //Employer 'only' information
    var businessName: String?
    
    //Employee 'only' information
    var dob: Date?
    var tfn: String?
    
    init(email: String){
        self.email = email;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        email <- map["email"]
        //address <- map["address"]
        phone <- map["phone"]
        abn <- map["abn"]
        type <- map["type"]
        firstName <- map["firstName"]
        surname <- map["surname"]
    }
    
    

}






