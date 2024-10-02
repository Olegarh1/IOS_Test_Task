//
//  SnapchatView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit
import SnapKit

final class SnapchatView: UIView {
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
}

private extension SnapchatView {
    
    func setupSubviews() {
        self.backgroundColor = .yellow
    }
    
    func setupConstarints() {
        
    }
}
