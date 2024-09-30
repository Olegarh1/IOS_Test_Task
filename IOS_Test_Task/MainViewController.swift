//
//  ViewController.swift
//  IOS_Test_Еask
//
//  Created by Oleg Zakladnyi on 30.09.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    // MARK: - Private UI elements
    private let exportView = UIView()
    private let socialMediaView = UIView().after {
        $0.layer.borderColor = UIColor(hex: "#33343A").cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12.0
        $0.layer.shadowRadius = 4.0
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    private lazy var socialMediaSegment: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Instagram", "TikTok", "YouTube", "Snapchat"])
        segmentControl.tintColor = .white
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = UIColor(hex: "#33343A")
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        return segmentControl
    }()
    private let qualityView = UIView().after {
        $0.layer.borderColor = UIColor(hex: "#33343A").cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12.0
        $0.layer.shadowRadius = 4.0
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    private let watermarkView = UIView().after {
        $0.layer.borderColor = UIColor(hex: "#33343A").cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12.0
        $0.layer.shadowRadius = 4.0
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    private var sizeLabel = UILabel().after {
        $0.text = "Estimated File Size: 24.5 MB"
        $0.font = UIFont(name: "Inter-Medium", size: 13.0)
        
        $0.textColor = UIColor(hex: "#727479")
    }
    private lazy var editButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(named: "edit") {
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            button.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
        }
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont(name: "Inter-SemiBold", size: 20.0)
        configuration.attributedTitle = AttributedString("Edit", attributes: container)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8.0
        configuration.baseBackgroundColor = UIColor(hex: "#33343A")
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 27.0
        button.configuration = configuration
        
        return button
    }()
    private lazy var exportButton: UIButton = {
        let button = GradientButton()
        
        if let image = UIImage(named: "download") {
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            button.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
        }
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont(name: "Inter-SemiBold", size: 20.0)
        configuration.attributedTitle = AttributedString("Export", attributes: container)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8.0
        configuration.background.backgroundColor = .clear
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 27.0
        button.configuration = configuration
        
        button.startColor = UIColor(hex: "#0086E0")
        button.endColor = UIColor(hex: "#0071BD")
        
        //TODO: - Shadow
        button.layer.shadowColor = UIColor(hex: "#0071BD").cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 24.0
        
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImagesToSegments()
        setupSubviews()
        setupConstraints()
        view.backgroundColor = UIColor(hex: "#18191b")
    }
}

// MARK: - Setup private method's
private extension MainViewController {
    
    func setupSubviews() {
        [exportView,editButton,exportButton].forEach {
            view.addSubview($0)
        }
        [socialMediaView,qualityView,watermarkView,sizeLabel].forEach {
            exportView.addSubview($0)
        }
        socialMediaView.addSubview(socialMediaSegment)
    }
    
    func setupConstraints() {
        exportView.snp.makeConstraints {
            $0.height.equalTo(250.0)
            $0.bottom.equalTo(editButton.snp.top).offset(-56.0)
            $0.left.right.equalToSuperview().inset(16.0)
        }
        socialMediaView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(64.0)
        }
        socialMediaSegment.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8.0)
        }
        qualityView.snp.makeConstraints {
            $0.top.equalTo(socialMediaView.snp.bottom).inset(-8.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(socialMediaView.snp.height)
        }
        watermarkView.snp.makeConstraints {
            $0.top.equalTo(qualityView.snp.bottom).inset(-8.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(socialMediaView.snp.height)
        }
        sizeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        editButton.snp.makeConstraints {
            $0.height.equalTo(56.0)
            $0.width.equalTo(149.0)
            $0.left.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(40.0)
        }
        exportButton.snp.makeConstraints {
            $0.height.equalTo(editButton.snp.height)
            $0.left.equalTo(editButton.snp.right).offset(16.0)
            $0.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(40.0)
        }
    }
    
    func addImagesToSegments() {
        let images = ["mingcute_ins-line", "mingcute_tiktok-line", "mingcute_youtube-line", "mingcute_snapchat-line"]
        let title = ["Instagram", "TikTok", "YouTube", "Snapchat"]
        for index in 0...images.count - 1{
            if let image = UIImage(named: images[index])?.withRenderingMode(.alwaysTemplate) {
                let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
                socialMediaSegment.setImage(
                    UIImage.textEmbededImage(
                        image: resizedImage,
                        string: "", //Use title[index] to show title
                        color: .black
                    ),
                    forSegmentAt: index
                )
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

// MARK: - Private Objc-C method's
@objc private extension MainViewController {
    
    func editBtnTapped() {}
    
    func segmentChanged() {}
}
