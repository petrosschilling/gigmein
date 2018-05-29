//
//  Address.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: Mappable{
    
    var unit: String = ""
    var streetNumber: String = ""
    var streetName: String = ""
    var suburb: String = ""
    var city: String = ""
    var postcode: String = ""
    var state: String = ""
    var country: String = ""
    
    init(){
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        unit <- map["unit"]
        streetNumber <- map["streetNumber"]
        streetName <- map["streetName"]
        suburb <- map["suburb"]
        city <- map["city"]
        postcode <- map["postcode"]
        state <- map["state"]
        country <- map["country"]
    }
    
    func fullAddress() -> String {
        return "\(unit)/\(streetNumber) \(streetName) \(suburb) \(postcode) \(city) \(state) \(country)"
    }
    
}
