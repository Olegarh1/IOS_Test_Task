//
//  TikTokView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit
import SnapKit
import Photos
import CropViewController

final class TikTokView: UIView {
    
    // MARK: - Private UI-Elements
    private let avatarImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 18.0
        $0.isHidden = false
        
        if let image = UIImage(named: "avatar") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 36.0, height: 36.0))
            $0.image = resizedImage
        }
        
        let borderLayer = CALayer()
        borderLayer.borderColor = UIColor.white.cgColor
        borderLayer.borderWidth = 2.0
        borderLayer.frame = CGRect(x: -1, y: -1, width: 36 + 2, height: 36 + 2)
        borderLayer.cornerRadius = 18.0
        borderLayer.masksToBounds = true
        $0.layer.addSublayer(borderLayer)
    }
    private lazy var subscribeButton = UIButton().after{
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Inter-Bold", size: 20.0)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 9.0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(subscribeBtnTapped), for: .touchUpInside)
    }
    private lazy var likeButton = createButton(imageName: "like", target: #selector(likeBtnTapped))
    private lazy var likeTextField = createTextField(text: "250,5k")
    private lazy var commentButton = createButton(imageName: "comment", target: #selector(commentBtnTapped))
    private lazy var commentTextField = createTextField(text: "100k")
    private lazy var savedButton = createButton(imageName: "save", target: #selector(savedBtnTapped))
    private lazy var savedTextField = createTextField(text: "89k")
    private lazy var repostButton = createButton(imageName: "repost", target: #selector(repostBtnTapped))
    private lazy var repostTextField = createTextField(text: "132.5k")
    private let musicImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 18.0
        $0.isHidden = false
        
        if let image = UIImage(named: "music") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 36.0, height: 36.0))
            $0.image = resizedImage
        }
    }
    private let usernameTextField = UITextField().after {
        $0.text = "Name and Last name"
        $0.font = UIFont(name: "Inter-SemiBold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    private let captionTextView = UITextView().after {
        $0.text = "Caption of the post 😉"
        $0.font = UIFont(name: "Inter-SemiBold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.textContainerInset = .zero
    }
    private let tagsTextView = UITextView().after {
        $0.text = "#fyp"
        $0.font = UIFont(name: "Inter-SemiBold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.textContainerInset = .zero
    }
    private let translateTextField = UITextField().after {
        $0.text = "Show translation"
        $0.font = UIFont(name: "Inter-Regular", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.isUserInteractionEnabled = false
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    private let translateImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.isHidden = false
        
        if let image = UIImage(named: "translate") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 12.0, height: 12.0))
            $0.image = resizedImage.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
        }
    }
    private let songTextField = UITextField().after {
        $0.text = "Song name - song artist"
        $0.font = UIFont(name: "Inter-Regular", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
    }
    private let noteImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.isHidden = false
        
        if let image = UIImage(named: "note") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 12.0, height: 12.0))
            $0.image = resizedImage.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
        }
    }
    
    //MARK: - Private variebles
    private var likes: Double = 250500
    private var isLiked = false
    private var comments: Double = 100000
    private var isCommented = false
    private var saveds: Double = 89000
    private var isSaved = false
    private var reposts: Double = 132500
    private var isReposted = false
    private var isAvatarSelected = false
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupTextFields()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
        setupTextFields()
        setupTapGesture()
    }
}

private extension TikTokView {
    
    func setupSubviews() {
        tagsTextView.delegate = self
        captionTextView.delegate = self
        self.backgroundColor = .clear
        [avatarImageView, subscribeButton, likeButton, likeTextField, commentButton, commentTextField, savedButton, savedTextField, repostButton, repostTextField, musicImageView, translateTextField, usernameTextField, captionTextView, tagsTextView, translateImageView, songTextField, noteImageView].forEach {
            addSubview($0)
        }
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints {
            $0.bottom.equalTo(likeButton.snp.top).inset(-16.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
        }
        subscribeButton.snp.makeConstraints {
            $0.width.height.equalTo(18.0)
            $0.bottom.equalTo(avatarImageView.snp.bottom).inset(-9.0)
            $0.centerX.equalTo(likeButton.snp.centerX)
        }
        likeButton.snp.makeConstraints {
            $0.bottom.equalTo(likeTextField.snp.top).inset(-8.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
        }
        likeTextField.snp.makeConstraints {
            $0.bottom.equalTo(commentButton.snp.top).inset(-8.0)
            $0.centerX.equalTo(commentButton.snp.centerX)
        }
        commentButton.snp.makeConstraints {
            $0.bottom.equalTo(commentTextField.snp.top).inset(-8.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
        }
        commentTextField.snp.makeConstraints {
            $0.bottom.equalTo(savedButton.snp.top).inset(-8.0)
            $0.centerX.equalTo(savedButton.snp.centerX)
        }
        savedButton.snp.makeConstraints {
            $0.bottom.equalTo(savedTextField.snp.top).inset(-8.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
        }
        savedTextField.snp.makeConstraints {
            $0.bottom.equalTo(repostButton.snp.top).inset(-8.0)
            $0.centerX.equalTo(repostButton.snp.centerX)
        }
        repostButton.snp.makeConstraints {
            $0.bottom.equalTo(repostTextField.snp.top).inset(-8.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
        }
        repostTextField.snp.makeConstraints {
            $0.bottom.equalTo(musicImageView.snp.top).inset(-8.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
        }
        musicImageView.snp.makeConstraints {
            $0.centerY.equalTo(noteImageView.snp.centerY)
            $0.right.equalToSuperview().inset(8.0)
        }
        usernameTextField.snp.makeConstraints {
            $0.bottom.equalTo(captionTextView.snp.top).inset(-8.0)
            $0.left.equalTo(translateImageView.snp.left)
        }
        captionTextView.snp.makeConstraints {
            $0.width.equalTo(tagsTextView.snp.width)
            $0.bottom.equalTo(tagsTextView.snp.top).inset(-8.0)
            $0.left.equalTo(translateImageView.snp.left).inset(-4.0)
        }
        tagsTextView.snp.makeConstraints {
            $0.width.equalTo(songTextField.snp.width)
            $0.bottom.equalTo(translateTextField.snp.top).inset(-8.0)
            $0.left.equalTo(translateImageView.snp.left).inset(-4.0)
        }
        translateTextField.snp.makeConstraints {
            $0.centerY.equalTo(translateImageView.snp.centerY)
            $0.left.equalTo(translateImageView.snp.right).inset(-8.0)
        }
        translateImageView.snp.makeConstraints {
            $0.bottom.equalTo(noteImageView.snp.top).inset(-8.0)
            $0.left.equalToSuperview().inset(16.0)
        }
        songTextField.snp.makeConstraints {
            $0.width.equalTo(120.0)
            $0.centerY.equalTo(noteImageView.snp.centerY)
            $0.left.equalTo(noteImageView.snp.right).inset(-8.0)
        }
        noteImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.left.equalToSuperview().inset(16.0)
        }
    }
    
    func createButton(imageName: String, target: Selector) -> UIButton {
        let button = UIButton()
        if let image = UIImage(named: imageName) {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            button.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
        }
        button.addTarget(self, action: target, for: .touchUpInside)
        return button
    }

    func createTextField(text: String, fontSize: CGFloat = 10.0, textColor: UIColor = .white, alignment: NSTextAlignment = .center) -> UITextField {
            let textField = CountTextField()
            textField.text = text
            textField.font = UIFont(name: "Inter-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            textField.textColor = textColor
            textField.textAlignment = alignment
            return textField
        }
    
    func setupTextFields() {
        [likeTextField, commentTextField, savedTextField, repostTextField, usernameTextField, songTextField].forEach{
            $0.delegate = self
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tapGesture)
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        avatarImageView.isUserInteractionEnabled = true
        let musicTapGesture = UITapGestureRecognizer(target: self, action: #selector(musicTapped))
        musicImageView.addGestureRecognizer(musicTapGesture)
        musicImageView.isUserInteractionEnabled = true
    }
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        if let parentVC = self.parentViewController {
            parentVC.present(picker, animated: true)
        }
    }
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .circular, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = true
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        if let parentVC = self.parentViewController {
            parentVC.present(vc, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TikTokView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case likeTextField:
            likeTextField.text = "\(Int(likes))"
        case commentTextField:
            commentTextField.text = "\(Int(comments))"
        case savedTextField:
            savedTextField.text = "\(Int(saveds))"
        case repostTextField:
            repostTextField.text = "\(Int(reposts))"
        default:
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            
        case _ as CountTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 10
            
        case usernameTextField:
            return range.location < 24
        case songTextField:
            return range.location < 24
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let number = Double(text) else { return }
        switch textField {
        case likeTextField:
            likes = number
            likeTextField.text = number.formatNumber()
        case commentTextField:
            comments = number
            commentTextField.text = number.formatNumber()
        case savedTextField:
            saveds = number
            savedTextField.text = number.formatNumber()
        case repostTextField:
            reposts = number
            repostTextField.text = number.formatNumber()
        default:
            return
        }
    }
}

// MARK: - UITextViewDelegate
extension TikTokView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case tagsTextView:
            let currentText = textView.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
            let newTags = newText.split { $0 == " " || $0 == "\n" }.map { String($0) }
            
            if !newText.hasPrefix("#") {
                textView.text = "#" + newText
                return false
            } else if newTags.count > 10 {
                return false
            }
            
            return true
        case captionTextView:
            //TODO: - ...more and ...less
            return range.location < 240
        default:
            return true
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TikTokView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CropViewControllerDelegate
extension TikTokView: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 36.0, height: 36.0))
        if isAvatarSelected == true {
            avatarImageView.image = resizedImage
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.layer.masksToBounds = true
        } else {
            musicImageView.image = resizedImage
            musicImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            musicImageView.layer.masksToBounds = true
        }
        cropViewController.dismiss(animated: true)
    }
}

// MARK: - Private Objc-C methods
@objc private extension TikTokView {
    
    func subscribeBtnTapped() {
        subscribeButton.isHidden = true
    }
    
    func avatarTapped() {
        isAvatarSelected = true
        self.presentImagePicker()
    }
    
    func musicTapped() {
        isAvatarSelected = false
        self.presentImagePicker()
    }
    
    func likeBtnTapped() {
        likeButton.tintColor = isLiked ? .white : .red
        likes += isLiked ? -1 : 1
        likeTextField.text = likes.formatNumber()
        isLiked.toggle()
    }
    
    func commentBtnTapped() {
        commentButton.tintColor = isCommented ? .white : .darkGray
        comments += isCommented ?  -1 : 1
        commentTextField.text = comments.formatNumber()
        isCommented.toggle()
    }
    
    func savedBtnTapped() {
        savedButton.tintColor = isSaved ? .white : .yellow
        saveds += isSaved ?  -1 : 1
        savedTextField.text = saveds.formatNumber()
        isSaved.toggle()
    }
    
    func repostBtnTapped() {
        repostButton.tintColor = isReposted ? .white : .darkGray
        reposts += isReposted ?  -1 : 1
        repostTextField.text = reposts.formatNumber()
        isReposted.toggle()
    }
    
    func hideKeyboard() {
        [likeTextField, commentTextField, savedTextField, repostTextField, usernameTextField, captionTextView, tagsTextView, songTextField].forEach{
            $0.resignFirstResponder()
        }
    }
}
