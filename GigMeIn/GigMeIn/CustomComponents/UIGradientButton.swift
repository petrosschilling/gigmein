//
//  UIGradientButton.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class UIGradientButton: UIButton {
    
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
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.updateView()
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }


}
