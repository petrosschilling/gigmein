//
//  Address.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/3/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class Address{
    
    var unit: String
    var streetNumber: String
    var streetName: String
    var suburb: String
    var city: String
    var postcode: String
    var state: String
    var country: String
    
    init(unit: String, streetNumber: String, streetName: String, suburb: String, city: String, postcode: String, state: String, country: String) {
        self.unit = unit
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.suburb = suburb
        self.city = city
        self.postcode = postcode
        self.state = postcode
        self.country = country
    }
    
    func fullAddress() -> String {
        return "\(unit)/\(streetNumber) \(streetName) \(suburb) \(postcode) \(city) \(state) \(country)"
    }
    
}
