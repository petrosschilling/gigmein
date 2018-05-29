//
//  JobPost.swift
//  GigMeIn
//
//  Created by Petros Schilling on 28/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import ObjectMapper

class JobPost: Entity{
    
    var employer: User?
    var title: String = ""
    var description: String = ""
    var dueDate : Date = Date()
    var address: Address?
    var rate: Double = 0.0
    var paymentType: PaymentType?
    
    var numberOfApplications: Int = 0
    
    override init(){
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        employer <- map["employer"]
        title <- map["title"]
        description <- map["description"]
        dueDate <- map["dueDate"]
        address <- map["address"]
        rate <- map["rate"]
        paymentType <- map["paymentType"]
        numberOfApplications <- map["numberOfApplications"]
    }
    
}
