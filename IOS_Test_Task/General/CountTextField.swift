//
//  CountTextField.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 02.10.2024.
//

import UIKit

class CountTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        self.text = "110k"
        self.font = UIFont(name: "Inter-SemiBold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        self.keyboardType = .numberPad
        self.textColor = .white
        self.backgroundColor = .clear
        self.textAlignment = .center
        self.isHidden = false
        self.layer.zPosition = 1
    }
}
