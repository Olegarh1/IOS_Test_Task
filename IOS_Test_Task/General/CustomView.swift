//
//  CustomView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit

class CustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.borderColor = UIColor(hex: "#33343A").cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 12.0
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}
