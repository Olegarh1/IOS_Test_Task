//
//  ViewController.swift
//  IOS_Test_Еask
//
//  Created by Oleg Zakladnyi on 30.09.2024.
//

import UIKit
import SnapKit
import Photos

class MainViewController: UIViewController {
    
    // MARK: - Private UI elements
    private let instagramView = InstagramView().after{
        $0.isHidden = true
    }
    private let tikTokView = TikTokView().after{
        $0.isHidden = false
        $0.layer.zPosition = 0
    }
    private let youTubeView = YouTubeView().after{
        $0.isHidden = true
    }
    private let snapchatView = SnapchatView().after{
        $0.isHidden = true
    }
    private let markLabel = UILabel().after {
        $0.layer.zPosition = 1
        $0.text = "Watermark"
        $0.textColor = .red
        $0.font = UIFont(name: "Inter-SemiBold", size: 36.0)
        $0.alpha = 0.5
        $0.transform = CGAffineTransform(rotationAngle: -45 * .pi / 180)
    }
    private let exportView = UIView()
    private let socialMediaView = CustomView()
    private lazy var socialMediaSegment: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Instagram", "TikTok", "YouTube", "Snapchat"])
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(mediaSegmentChanged), for: .valueChanged)
        segmentControl.selectedSegmentTintColor = UIColor(hex: "#33343A")
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let separator = UIColor(hex: "#18191b").image()
        segmentControl.setDividerImage(separator, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.layer.shadowColor = UIColor(hex: "#18191b").cgColor
        
        return segmentControl
    }()
    private let qualityView = CustomView()
    private lazy var qualitySegment: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Standart", "HD", "4K"])
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Inter-SemiBold", size: 16.0)
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .normal)
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(qualitySegmentChanged), for: .valueChanged)
        segmentControl.selectedSegmentTintColor = UIColor(hex: "#33343A")
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let separator = UIColor(hex: "#18191b").image()
        segmentControl.setDividerImage(separator, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.layer.shadowColor = UIColor(hex: "#18191b").cgColor
        
        return segmentControl
    }()
    private let proLabel = ProLabel()
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
    private var sizeLabel = UILabel().after {
        $0.text = "Estimated File Size: 24.5 MB"
        $0.font = UIFont(name: "Inter-Medium", size: 13.0)
        $0.textColor = UIColor(hex: "#727479")
    }
    private lazy var editButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(named: "edit") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
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
        button.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        
        return button
    }()
    private lazy var exportButton: UIButton = {
        let button = GradientButton()
        
        if let image = UIImage(named: "download") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
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
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImagesToSegments()
        setupSubviews()
        setupConstraints()
    }
}

// MARK: - Setup private method's
private extension MainViewController {
    
    func setupSubviews() {
        view.backgroundColor = UIColor(hex: "#18191b")
        proLabel.isHidden = true
//        watermarkSwitch.isHidden = true
        tikTokView.addSubview(markLabel)
        [instagramView, tikTokView, youTubeView, snapchatView, exportView, editButton, exportButton].forEach {
            view.addSubview($0)
        }
        [socialMediaView, qualityView, watermarkView, sizeLabel].forEach {
            exportView.addSubview($0)
        }
        socialMediaView.addSubview(socialMediaSegment)
        watermarkView.addSubview(watermarkLabel)
        watermarkView.addSubview(watermarkSwitch)
        watermarkView.addSubview(proLabel)
        qualityView.addSubview(qualitySegment)
    }
    
    func setupConstraints() {
        instagramView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(exportView.snp.top).inset(-16.0)
        }
        tikTokView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(exportView.snp.top).inset(-16.0)
        }
        markLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        youTubeView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(exportView.snp.top).inset(-16.0)
        }
        snapchatView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(exportView.snp.top).inset(-16.0)
        }
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
        qualitySegment.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8.0)
        }
        watermarkView.snp.makeConstraints {
            $0.top.equalTo(qualityView.snp.bottom).inset(-8.0)
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
        proLabel.snp.makeConstraints {
            $0.width.equalTo(45.0)
            $0.height.equalTo(26.0)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16.0)
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
    
    func presentImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        vc.mediaTypes = ["public.image", "public.movie"]
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.tikTokView.displayImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Objc-C method's
@objc private extension MainViewController {
    
    func editBtnTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.presentImagePicker()
                }
            case .denied, .restricted:
                print("Access denied")
            case .notDetermined:
                DispatchQueue.main.async {
                    self.presentImagePicker()
                }
            default:
                break
            }
        }
    }
    
    func qualitySegmentChanged() {}
    
    func mediaSegmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            instagramView.isHidden = false
            [tikTokView,youTubeView,snapchatView].forEach {
                $0.isHidden = true
            }
        case 1:
            tikTokView.isHidden = false
            [instagramView,youTubeView,snapchatView].forEach {
                $0.isHidden = true
            }
        case 2:
            youTubeView.isHidden = false
            [instagramView,tikTokView,snapchatView].forEach {
                $0.isHidden = true
            }
        case 3:
            snapchatView.isHidden = false
            [tikTokView,youTubeView,instagramView].forEach {
                $0.isHidden = true
            }
        default:
            return
        }
    }
    
    func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            markLabel.isHidden = true
            sender.thumbTintColor = UIColor(hex: "#0086E0")
        } else {
            markLabel.isHidden = false
            sender.thumbTintColor = UIColor(hex: "#64656D")
        }
    }
}
