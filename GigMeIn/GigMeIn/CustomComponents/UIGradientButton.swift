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
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }


}
