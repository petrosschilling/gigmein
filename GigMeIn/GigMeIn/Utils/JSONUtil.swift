//
//  JSONAble.swift
//  GigMeIn
//
//  Created by Petros Schilling on 1/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation

class JSONUtil{
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
