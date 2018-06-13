//
//  AlertUtils.swift
//  GigMeIn
//
//  Created by Petros Schilling on 5/6/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit

class AlertUtils{
    
    static func showAlertWithOk(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
