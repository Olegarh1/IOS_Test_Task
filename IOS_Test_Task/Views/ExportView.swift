//
//  ExportView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 10.10.2024.
//

import UIKit

protocol QualitySegmentDelegate: AnyObject {
    func updateTrialMode(_ value: Int)
}

final class ExportView: UIView {
    
    //MARK: - Private UI-Elements
    private let socialMediaView = CustomView()
    private lazy var socialMediaSegment: UISegmentedControl = createSegmentedControl(
        items: ["Instagram", "TikTok", "YouTube", "Snapchat"],
        selectedIndex: 2,
        target: self,
        action: #selector(mediaSegmentChanged),
        backgroundColor: UIColor.black.withAlphaComponent(0.5),
        tintColor: UIColor(hex: "#33343A"),
        separatorColorHex: "#18191b"
    )
    private lazy var qualitySegment = SegmentedControl().after {
        $0.delegate = self
    }
    private lazy var proButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(named: "PRO") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 45.0, height: 26.0))
            button.setImage(resizedImage, for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
        }
        button.addTarget(self, action: #selector(proBtnTapped), for: .touchUpInside)
        return button
    }()
    private let watermarkView = CustomView()
    private let watermarkLabel = UILabel().after {
        $0.text = "Remove Watermark"
        $0.font = UIFont(name: "Inter-SemiBold", size: 16.0)
        $0.textColor = UIColor(hex: "#A0A2AF")
    }
    private lazy var watermarkSwitch = UISwitch().after {
        $0.tintColor = UIColor(hex: "#33343A")
        $0.onTintColor = UIColor(hex: "#33343A")
        $0.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        $0.thumbTintColor = UIColor(hex: "#64656D")
    }
    
    //MARK: - Delegate
    weak var delegate: ExportViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addImagesToSegments()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImagesToSegments()
        setupSubviews()
        setupConstraints()
    }
    
    func updateSubscriptionStatus(isSubscribed: Bool) {
        proButton.isHidden = isSubscribed
        qualitySegment.updateSubscriptionStatus(isSubscribed: isSubscribed)
    }
}

//MARK: - Private extension
private extension ExportView {
    
    func setupSubviews() {
        [socialMediaView, qualitySegment, watermarkView].forEach {
            self.addSubview($0)
        }
        socialMediaView.addSubview(socialMediaSegment)
        watermarkView.addSubview(watermarkLabel)
        watermarkView.addSubview(watermarkSwitch)
        watermarkView.addSubview(proButton)
    }
    
    func setupConstraints() {
        socialMediaView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(64.0)
        }
        socialMediaSegment.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8.0)
        }
        qualitySegment.snp.makeConstraints {
            $0.top.equalTo(socialMediaView.snp.bottom).inset(-8.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(socialMediaView.snp.height)
        }
        watermarkView.snp.makeConstraints {
            $0.top.equalTo(qualitySegment.snp.bottom).inset(-8.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(socialMediaView.snp.height)
        }
        watermarkLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16.0)
        }
        watermarkSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16.0)
        }
        proButton.snp.makeConstraints {
            $0.width.equalTo(45.0)
            $0.height.equalTo(26.0)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16.0)
        }
    }
    
    func createSegmentedControl(items: [String], selectedIndex: Int, target: Any?, action: Selector, backgroundColor: UIColor, tintColor: UIColor, separatorColorHex: String, fontSize: CGFloat = 16.0) -> UISegmentedControl {
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = selectedIndex
        segmentControl.selectedSegmentTintColor = tintColor
        segmentControl.backgroundColor = backgroundColor
        segmentControl.addTarget(target, action: action, for: .valueChanged)
        
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Inter-SemiBold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        let separator = UIColor(hex: separatorColorHex).image()
        segmentControl.setDividerImage(separator, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.layer.shadowColor = UIColor(hex: "#18191b").cgColor
        
        return segmentControl
    }
    
    func addImagesToSegments() {
        let images = ["mingcute_ins-line", "mingcute_tiktok-line", "mingcute_youtube-line", "mingcute_snapchat-line"]
        for index in 0...images.count - 1{
            if let image = UIImage(named: images[index])?.withRenderingMode(.alwaysTemplate) {
                let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
                socialMediaSegment.setImage(
                    UIImage.textEmbededImage(
                        image: resizedImage,
                        string: "",
                        color: .black
                    ),
                    forSegmentAt: index
                )
            }
        }
        socialMediaSegment.tintColor = .white
    }
}

//MARK: - QualitySegmentDelegate
extension ExportView: QualitySegmentDelegate {
    
    func updateTrialMode(_ value: Int) {
        delegate?.updateTrialMode(5)
    }
}

//MARK: - Private Objc-C method's
@objc private extension ExportView {
    
    func proBtnTapped(_ sender: UIButton) {
        delegate?.updateTrialMode(5)
    }
    
    func mediaSegmentChanged(sender: UISegmentedControl) {
        let selectedIndex = socialMediaSegment.selectedSegmentIndex
        delegate?.showSocialView(selectedIndex)
    }
    
    func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            delegate?.updateMark(true)
            sender.thumbTintColor = UIColor(hex: "#0086E0")
        } else {
            delegate?.updateMark(false)
            sender.thumbTintColor = UIColor(hex: "#64656D")
        }
    }
}
