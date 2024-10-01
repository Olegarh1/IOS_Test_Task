//
//  ProLabel.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit

class ProLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        self.text = "PRO"
        self.textColor = .black
        self.font = UIFont(name: "Inter-SemiBold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        self.textAlignment = .center
        self.backgroundColor = UIColor(hex: "#FEA51B")
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
    }
}
