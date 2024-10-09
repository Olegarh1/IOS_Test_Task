//
//  ViewController.swift
//  IOS_Test_Еask
//
//  Created by Oleg Zakladnyi on 30.09.2024.
//

import UIKit
import SnapKit
import Photos
import AVKit
import AVFoundation
import CropViewController
import KeychainAccess

protocol SegmentedControlDelegate: AnyObject {
    func updateTrialMode(_ value: Int)
}

class MainViewController: UIViewController {
    
    // MARK: - Private UI elements
    private let instagramView = InstagramView().after{
        $0.isHidden = true
        $0.layer.zPosition = 1
    }
    private let tikTokView = TikTokView().after{
        $0.isHidden = true
        $0.layer.zPosition = 1
    }
    private let youTubeView = YouTubeView().after{
        $0.isHidden = true
        $0.layer.zPosition = 1
    }
    private let snapchatView = SnapchatView().after{
        $0.isHidden = true
        $0.layer.zPosition = 1
    }
    private let imageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 16.0
        $0.layer.zPosition = 0
    }
    private let videoContainerView = UIView().after {
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 16.0
        $0.layer.zPosition = 0
        $0.clipsToBounds = true
    }
    private let markLabel = UILabel().after {
        $0.layer.zPosition = 1
        $0.text = "Choose your media"
        $0.textColor = .red
        $0.font = UIFont(name: "Inter-SemiBold", size: 32.0)
        $0.alpha = 0.5
        $0.transform = CGAffineTransform(rotationAngle: -45 * .pi / 180)
    }
    private let exportView = UIView()
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
    private lazy var qualitySegment = SegmentedControl()
    private lazy var proButton: UIButton = {
        let button = UIButton()
        
        if let image = UIImage(named: "PRO") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 36.0, height: 36.0))
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
    private var sizeLabel = UILabel().after {
        $0.text = ""
        $0.font = UIFont(name: "Inter-Medium", size: 13.0)
        $0.textColor = UIColor(hex: "#727479")
    }
    private lazy var editButton = createButton(image: "edit", title: "Edit", backgroundColor: UIColor(hex: "#33343A"), action: #selector(editBtnTapped))
    private lazy var exportButton = createButton(image: "download", title: "Export", startColor: UIColor(hex: "#0086E0"), endColor: UIColor(hex: "#0071BD"), action: #selector(exportButtonTapped))
    private lazy var galleryButton = createButton(image: "gallery", title: "Select", startColor: .red, endColor: .orange, action: #selector(galleryBtnTapped))
    
    //MARK: - Private variebles
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoURL: URL?
    private var trialMode: Int = 0 {
        didSet {
            saveDataToKeychaine(int: trialMode)
            isUserSubscribed()
        }
    }
    private var isMediaSelected: Bool = false {
        didSet {
            updateViewVisibility()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addImagesToSegments()
        setupSubviews()
        setupConstraints()
        isUserSubscribed()
    }
}

// MARK: - Setup private method's
private extension MainViewController {
    
    func setupSubviews() {
        qualitySegment.delegate = self
        editButton.isEnabled = false
        exportButton.isEnabled = false
        view.backgroundColor = UIColor(hex: "#18191b")
        [instagramView, tikTokView, youTubeView, snapchatView, imageView, videoContainerView, exportView, editButton, exportButton, galleryButton, markLabel].forEach {
            view.addSubview($0)
        }
        [socialMediaView, qualitySegment, watermarkView, sizeLabel].forEach {
            exportView.addSubview($0)
        }
        socialMediaView.addSubview(socialMediaSegment)
        watermarkView.addSubview(watermarkLabel)
        watermarkView.addSubview(watermarkSwitch)
        watermarkView.addSubview(proButton)
    }
    
    func setupConstraints() {
        instagramView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(tikTokView.snp.bottom)
        }
        tikTokView.snp.makeConstraints {
            $0.width.equalTo(234.0)
            $0.height.equalTo(416.0)
            $0.top.equalTo(imageView.snp.top)
            $0.centerX.equalTo(imageView.snp.centerX)
        }
        markLabel.snp.makeConstraints {
            $0.centerY.equalTo(tikTokView.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        youTubeView.snp.makeConstraints {
            $0.width.equalTo(tikTokView.snp.width)
            $0.height.equalTo(tikTokView.snp.height)
            $0.top.equalTo(imageView.snp.top)
            $0.centerX.equalTo(imageView.snp.centerX)
        }
        snapchatView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(tikTokView.snp.bottom)
        }
        imageView.snp.makeConstraints{
            $0.width.equalTo(234.0)
            $0.height.equalTo(416.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(52.0)
        }
        videoContainerView.snp.makeConstraints{
            $0.width.equalTo(234.0)
            $0.height.equalTo(416.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(52.0)
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
        sizeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8.0)
        }
        galleryButton.snp.makeConstraints {
            $0.height.equalTo(46.0)
            $0.left.right.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(editButton.snp.top).inset(-8.0)
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
            $0.bottom.equalTo(editButton.snp.bottom)
        }
    }
    
    func createButton(image: String, title: String, backgroundColor: UIColor = .clear, startColor: UIColor = .clear, endColor: UIColor = .clear, action: Selector) -> UIButton {
        let button = GradientButton()
        
        if let image = UIImage(named: image) {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            button.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont(name: "Inter-SemiBold", size: 20.0)
        configuration.attributedTitle = AttributedString(title, attributes: container)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8.0
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 27.0
        button.configuration = configuration
        button.addTarget(self, action: action, for: .touchUpInside)
        button.startColor = startColor
        button.endColor = endColor
        
        return button
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

    func presentImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.mediaTypes = ["public.image", "public.movie"]
        self.present(vc, animated: true, completion: nil)
    }
    
    func showVideo(url: URL) {
        videoURL = url
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = .resizeAspect
        
        videoContainerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        videoContainerView.layer.addSublayer(playerLayer!)
        
        player?.play()
        updateSizeLabelForMedia(mediaURL: url)
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
    }

    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetCustom
        vc.customAspectRatio = CGSize(width: 9, height: 16)
        vc.aspectRatioLockEnabled = true
        vc.aspectRatioPickerButtonHidden = true
        vc.resetAspectRatioEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func updateSizeLabelForMedia(mediaURL: URL?) {
        guard let mediaURL = mediaURL else { return }
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: mediaURL.path)
            if let fileSize = fileAttributes[FileAttributeKey.size] as? Int64 {
                let fileSizeInMB = Double(fileSize) / (1024.0 * 1024.0)
                sizeLabel.text = String(format: "Estimated File Size: %.2f MB", fileSizeInMB)
            }
        } catch {
            print("Error getting file size: \(error.localizedDescription)")
        }
    }

    func updateSizeLabelForImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let imageSizeInMB = Double(imageData.count) / (1024.0 * 1024.0)
            sizeLabel.text = String(format: "Estimated File Size: %.2f MB", imageSizeInMB)
        }
    }
    
    func updateViewVisibility() {
        let selectedIndex = socialMediaSegment.selectedSegmentIndex
        [instagramView, tikTokView, youTubeView, snapchatView].enumerated().forEach { index, view in
            view.isHidden = index != selectedIndex || !isMediaSelected
        }
        markLabel.text = "Watermark"
        exportButton.isEnabled = isMediaSelected
        editButton.isEnabled = isMediaSelected
    }
    
    func saveImage() {
        guard let _ = imageView.image else {
            print("No image to export.")
            return
        }
        
        let components = [instagramView, tikTokView, youTubeView, snapchatView, markLabel]
        components.forEach {
            $0.frame = imageView.bounds
            imageView.addSubview($0)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let exportedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let finalImage = exportedImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func saveDataToKeychaine(int: Int) {
        let keychain = Keychain(service: "Oleg.IOS-Test-Task")
        keychain["TrialMode"] = String(int)
    }
    
    func loadDataFromKeychaine() -> Int {
        let keychain = Keychain(service: "Oleg.IOS-Test-Task")
        guard let trialDays = keychain["TrialMode"] else { return 0 }
        return Int(trialDays) ?? 0
    }
    
    func isUserSubscribed() {
        if loadDataFromKeychaine() > 0 {
            proButton.isHidden = true
            watermarkSwitch.isHidden = false
            qualitySegment.updateSubscriptionStatus(isSubscribed: true)
        } else {
            markLabel.isHidden = false
            proButton.isHidden = false
            watermarkSwitch.isHidden = true
            qualitySegment.updateSubscriptionStatus(isSubscribed: false)
        }
    }
    
    func showAlertController() {
        let alert = UIAlertController(
            title: "Trial Period",
            message: "You granted trial period for 5 exports",
            preferredStyle: .alert
        )
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.trialMode = 5
        }
        
        let declineAction = UIAlertAction(title: "Decline", style: .cancel) { _ in
            self.trialMode = 0
        }

        alert.addAction(acceptAction)
        alert.addAction(declineAction)
 
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - CropViewControllerDelegate
extension MainViewController: SegmentedControlDelegate {
    func updateTrialMode(_ value: Int) {
        showAlertController()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String {
                if mediaType == "public.image", let image = info[.originalImage] as? UIImage {
                    imageView.isHidden = false
                    videoContainerView.isHidden = true
                    picker.dismiss(animated: true, completion: nil)
                    showCrop(image: image)
                } else if mediaType == "public.movie", let videoURL = info[.mediaURL] as? URL {
                    showVideo(url: videoURL)
                    isMediaSelected = true
                    videoContainerView.isHidden = false
                    imageView.isHidden = true
                    picker.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CropViewControllerDelegate
extension MainViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageView.image = image
        isMediaSelected = true
        updateSizeLabelForImage(image: image)
        cropViewController.dismiss(animated: true)
    }
}

// MARK: - Private Objc-C method's
@objc private extension MainViewController {
    
    func proBtnTapped(_ sender: UIButton) {
        showAlertController()
    }
    
    func editBtnTapped(_ sender: UIButton) {
        youTubeView.isEdit.toggle()
        tikTokView.isEdit.toggle()
    }
    
    func exportButtonTapped(_ sender: UIButton) {
        saveImage()
        if trialMode != 0 {
            trialMode = trialMode - 1
            print("trial \(trialMode)")
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert: UIAlertController
        
        if let error = error {
            alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Success", message: "The image successfully saved.", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func playerDidFinishPlaying() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }

    func galleryBtnTapped(_ sender: UIButton) {
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
    
    func mediaSegmentChanged(sender: UISegmentedControl) {
        if isMediaSelected {
            let selectedIndex = socialMediaSegment.selectedSegmentIndex
            [instagramView, tikTokView, youTubeView, snapchatView].enumerated().forEach { index, view in
                view.isHidden = index != selectedIndex || !isMediaSelected
            }
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
