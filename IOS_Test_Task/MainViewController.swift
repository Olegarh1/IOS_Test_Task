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

protocol ExportViewDelegate: AnyObject {
    func updateTrialMode(_ value: Int)
    func updateMark(_ state: Bool)
    func showSocialView(_ index: Int)
}

class MainViewController: UIViewController {
    
    // MARK: - Private UI elements
    private let socialMediaView = UIView().after {
        $0.layer.zPosition = 1
    }
    private let instagramView = InstagramView().after {
        $0.isHidden = true
    }
    private let tikTokView = TikTokView().after{
        $0.isHidden = true
    }
    private let youTubeView = YouTubeView().after {
        $0.isHidden = true
    }
    private let snapchatView = SnapchatView().after{
        $0.isHidden = true
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
    private let exportView = ExportView()
    private var sizeLabel = UILabel().after {
        $0.text = ""
        $0.font = UIFont(name: "Inter-Medium", size: 13.0)
        $0.textColor = UIColor(hex: "#727479")
    }
    private lazy var editButton = createButton(image: "edit", title: "Edit", backgroundColor: UIColor(hex: "#33343A"), action: #selector(editBtnTapped))
    private lazy var exportButton = createButton(image: "download", title: "Export", startColor: UIColor(hex: "#0086E0"), endColor: UIColor(hex: "#0071BD"), action: #selector(exportButtonTapped))
    private lazy var galleryButton = createButton(image: "gallery", title: "Select", startColor: .red, endColor: .orange, action: #selector(galleryBtnTapped))
    private let loadingIndicator = UIActivityIndicatorView(style: .large).after {
        $0.layer.zPosition = 2
        $0.hidesWhenStopped = true
        $0.color = .white
    }
    
    //MARK: - Private variebles
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoURL: URL?
    private var isVideo: Bool?
    private lazy var trialMode: Int = loadDataFromKeychaine() {
        didSet {
            saveDataToKeychaine(int: trialMode)
            isUserSubscribed()
        }
    }
    private var isMediaSelected: Bool = false {
        didSet {
            updateViewVisibility()
            showSocialView(mediaIndex)
        }
    }
    private var mediaIndex = 2 {
        didSet {
            showSocialMedias(selectedIndex: mediaIndex)
        }
    }
    private var isMarkHidden = false {
        didSet {
            showMarkLabel(state: isMarkHidden)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        isUserSubscribed()
    }
}

// MARK: - Setup private method's
private extension MainViewController {
    
    func setupSubviews() {
        exportView.delegate = self
        editButton.isEnabled = false
        exportButton.isEnabled = false
        view.backgroundColor = UIColor(hex: "#18191b")
        view.addSubview(exportView)
        [socialMediaView, exportView, imageView, videoContainerView, editButton, exportButton, galleryButton, sizeLabel, loadingIndicator].forEach {
            view.addSubview($0)
        }
        [instagramView, tikTokView, youTubeView, snapchatView, markLabel].forEach {
            socialMediaView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        socialMediaView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.width)
            $0.height.equalTo(imageView.snp.height)
            $0.top.equalTo(imageView.snp.top)
            $0.centerX.equalTo(imageView.snp.centerX)
        }
        instagramView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tikTokView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        markLabel.snp.makeConstraints {
            $0.centerY.equalTo(tikTokView.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        youTubeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        snapchatView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints{
            $0.width.equalTo(imageView.snp.height).dividedBy(1.78)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(52.0)
            $0.bottom.equalTo(exportView.snp.top).inset(-8.0)
        }
        videoContainerView.snp.makeConstraints{
            $0.width.equalTo(videoContainerView.snp.height).dividedBy(1.78)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(52.0)
            $0.bottom.equalTo(exportView.snp.top).inset(-8.0)
        }
        exportView.snp.makeConstraints {
            $0.height.equalTo(210.0)
            $0.bottom.equalTo(sizeLabel.snp.top).inset(-8.0)
            $0.left.right.equalToSuperview().inset(16.0)
        }
        sizeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(galleryButton.snp.top).inset(-8.0)
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
        loadingIndicator.snp.makeConstraints {
            $0.centerY.equalTo(socialMediaView.snp.centerY)
            $0.centerX.equalToSuperview()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem )
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
        markLabel.text = "Watermark"
        exportButton.isEnabled = isMediaSelected
        editButton.isEnabled = isMediaSelected
    }
    
    func saveImage() {
        guard let _ = imageView.image else {
            print("No image to export.")
            return
        }
        
        loadingIndicator.startAnimating()
        socialMediaView.frame = imageView.bounds
        imageView.addSubview(socialMediaView)
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let exportedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let finalImage = exportedImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            loadingIndicator.stopAnimating()
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
            showMarkLabel(state: isMarkHidden)
            exportView.updateSubscriptionStatus(isSubscribed: true)
        } else {
            markLabel.isHidden = false
            exportView.updateSubscriptionStatus(isSubscribed: false)
        }
    }
    
    func showAlertController() {
        let alert = UIAlertController(title: "Trial Period", message: "You granted trial period for 5 exports", preferredStyle: .alert)
        
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
    
    func showSocialMedias(selectedIndex: Int) {
        [instagramView, tikTokView, youTubeView, snapchatView].enumerated().forEach { index, view in
            view.isHidden = index != selectedIndex || !isMediaSelected
        }
    }
    
    func showMarkLabel(state: Bool) {
        markLabel.isHidden = state
    }
}

// MARK: - SubscribtionDelegate
extension MainViewController: ExportViewDelegate {
    
    func showSocialView(_ selectedIndex: Int) {
        mediaIndex = selectedIndex
    }
    
    func updateMark(_ state: Bool) {
        isMarkHidden = state
    }
    
    func updateTrialMode(_ value: Int) {
        showAlertController()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.image", let image = info[.originalImage] as? UIImage {
                isVideo = false
                imageView.isHidden = false
                videoContainerView.isHidden = true
                picker.dismiss(animated: true, completion: nil)
                showCrop(image: image)
            } else if mediaType == "public.movie", let videoURL = info[.mediaURL] as? URL {
                isVideo = true
                showVideo(url: videoURL)
                isMediaSelected = true
                videoContainerView.isHidden = false
                imageView.isHidden = true
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        player?.play()
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
    
    func editBtnTapped(_ sender: UIButton) {
        youTubeView.isEdit.toggle()
        tikTokView.isEdit.toggle()
    }
    
    func exportButtonTapped(_ sender: UIButton) {
        guard let isVideoSelected = isVideo else { return }
        if isVideoSelected {
            if let url = videoURL {
                loadingIndicator.startAnimating()
                
                VideoHelper.convertVideoAndSaveTophotoLibrary(videoURL: url, watermarkLayerContents: socialMediaView.asImage().cgImage) { outputURL in
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        let alert: UIAlertController
                        if let _ = outputURL {
                            alert = UIAlertController(title: "Success", message: "The video successfully saved.", preferredStyle: .alert)
                        } else {
                            alert = UIAlertController(title: "Error", message: "Failed to save video", preferredStyle: .alert)
                        }
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            saveImage()
        }
        
        if trialMode != 0 {
            trialMode = trialMode - 1
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert: UIAlertController
        
        if let error = error {
            alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Success", message: "The image successfully saved.", preferredStyle: .alert)
        }
        
        loadingIndicator.stopAnimating()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func playerDidFinishPlaying() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    func galleryBtnTapped(_ sender: UIButton) {
        player?.pause()
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
}
