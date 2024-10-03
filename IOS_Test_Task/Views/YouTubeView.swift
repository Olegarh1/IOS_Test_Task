//
//  YouTubeView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit
import SnapKit

final class YouTubeView: UIView {
    
    //MARK: - Private UI-Elements
    private let progressLabel = UILabel().after {
        $0.text = "In Progress"
        $0.textColor = .darkGray
        $0.font = UIFont(name: "Inter-SemiBold", size: 48.0)
        $0.transform = CGAffineTransform(rotationAngle: -45 * .pi / 180)
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstarints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstarints()
    }
}

private extension YouTubeView {
    
    func setupSubviews() {
        self.backgroundColor = .red
        addSubview(progressLabel)
    }
    
    func setupConstarints() {
        progressLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
