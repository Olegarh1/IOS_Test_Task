//
//  UIView+Extension.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 30.09.2024.
//

import UIKit

@IBDesignable
final class GradientButton: UIButton {
    
    @IBInspectable var startColor: UIColor = UIColor.red {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.yellow {
        didSet {
            updateGradient()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
        gradientLayer.frame = rect
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2.0
        clipsToBounds = true
    }
    
    private func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
