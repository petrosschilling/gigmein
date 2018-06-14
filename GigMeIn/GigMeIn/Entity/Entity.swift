//
//  Entity.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import ObjectMapper

class Entity: Equatable, Mappable {
    
    var uid: String = ""
    var dateCreated: Date = nil ?? Date.init()
    
    init(){
        //dateCreated = Date.init()
    }
    
    static func ==(lhs: Entity, rhs: Entity) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.dateCreated == rhs.dateCreated
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        uid   <- map["uid"]
        dateCreated <- (map["dateCreated"], DateTransform())
    }
    

}
