//
//  MainUITabBarViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 1/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit

class MainUITabBarController: UITabBarController{
        
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
