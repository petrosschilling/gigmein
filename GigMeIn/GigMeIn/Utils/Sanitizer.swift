//
//  Sanitizer.swift
//  GigMeIn
//
//  Created by Petros Schilling on 5/6/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
class Sanitizer{
    
    static func trim(text: String) -> String{
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
