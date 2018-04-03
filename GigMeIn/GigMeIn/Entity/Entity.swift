//
//  Entity.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class Entity: Equatable, Hashable {
    
    var hashValue: Int
    var id: Int
    var dateCreated: Date
    
    init(){
        id = 0;
        dateCreated = Date.init()
        hashValue = dateCreated.hashValue
    }
    
    init(id: Int){
        self.id = id
        self.dateCreated = Date.init()
        self.hashValue = dateCreated.hashValue
    }
    
    init(id: Int, dateCreated: Date){
        self.id = id
        self.dateCreated = dateCreated
        self.hashValue = dateCreated.hashValue
    }
    
    static func ==(lhs: Entity, rhs: Entity) -> Bool {
        return lhs.id == rhs.id &&
            lhs.dateCreated == rhs.dateCreated
    }
    

}
