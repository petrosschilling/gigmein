//
//  UILoginTextField.swift
//  GigMeIn
//
//  Created by Petros Schilling on 30/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class UILoginTextField: UITextField {

    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var isOnlyBottomLine: Bool = false {
        didSet {
            self.updateView()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.updateView()
    }
    
    func updateView() {
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor

        let shape2 = CAShapeLayer()
        shape2.lineWidth = 1
        shape2.path = UIBezierPath(rect: self.bounds).cgPath
        shape2.strokeColor = UIColor.black.cgColor
        shape2.fillColor = UIColor.clear.cgColor
        
        if (!self.isOnlyBottomLine){
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(x: 2, y: 0, width: self.frame.width-2, height: 1)
            gradient.colors = [self.firstColor.cgColor, self.secondColor.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint (x: 1, y: 0.5)
            gradient.mask = shape
            self.layer.addSublayer(gradient)
        }

        let gradient2 = CAGradientLayer()
        gradient2.frame =  CGRect(x: 2, y: self.frame.height, width: self.frame.width-2, height: 1)
        gradient2.colors = [self.firstColor.cgColor, self.secondColor.cgColor]
        gradient2.startPoint = CGPoint(x: 0, y: 0.5)
        gradient2.endPoint = CGPoint (x: 1, y: 0.5)
        gradient2.mask = shape2
        self.layer.addSublayer(gradient2)
    }

}
