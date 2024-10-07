//
//  YouTubeView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit
import SnapKit
import Photos
import CropViewController

final class YouTubeView: UIView {
    
    //MARK: - Private UI-Elements
    private let avatarImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 13.0
        
        if let image = UIImage(named: "avatar") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 26.0, height: 26.0))
            $0.image = resizedImage
        }
    }
    private let usernameTextField = UITextField().after {
        $0.text = "@username"
        $0.font = UIFont(name: "Inter-SemiBold", size: 11.0) ?? UIFont.systemFont(ofSize: 11.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
    }
    private lazy var followButton = UIButton().after {
        $0.setTitle("Підписатися", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 10.0)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10.0
        $0.addTarget(self, action: #selector(followBTnTapped), for: .touchUpInside)
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
        $0.font = UIFont(name: "Inter-Bold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.textContainerInset = .zero
    }
    private lazy var likeButton = createButton(imageName: "like_youTube", target: #selector(likeBtnTapped))
    private lazy var likeTextField = createTextField(text: "467k")
    private lazy var unLikeButton = createButton(imageName: "unlike_youTube", target: #selector(unLikeBtnTapped))
    private lazy var unLikeTextField = createTextField(text: "2,5k")
    private lazy var commentButton = createButton(imageName: "comment_youTube", target: #selector(commentBtnTapped))
    private lazy var commentTextField = createTextField(text: "89k")
    private lazy var shareButton = createButton(imageName: "repost_youTube", target: #selector(shareBtnTapped))
    private lazy var shareTextField = createTextField(text: "130k")
    private lazy var remixButton = createButton(imageName: "remix_youTube", target: #selector(remixBtnTapped))
    private lazy var remixTextField = createTextField(text: "50,5k")
    private let musicImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4.0
        
        if let image = UIImage(named: "music_youTube") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 26.0, height: 26.0))
            $0.image = resizedImage
        }
    }
    
    //MARK: - Private variebles
    private var likes: Double = 467000
    private var isLiked = false
    private var unLikes: Double = 2500
    private var isUnLiked = false
    private var comments: Double = 89000
    private var isCommented = false
    private var shareds: Double = 130000
    private var isShared = false
    private var remixs: Double = 50500
    private var isRemixed = false
    private var isAvatarSelected = false
    private var isFollowed = false
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstarints()
        setupTextFields()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstarints()
        setupTextFields()
        setupTapGesture()
    }
}

private extension YouTubeView {
    
    func setupSubviews() {
        tagsTextView.delegate = self
        captionTextView.delegate = self
        self.backgroundColor = .clear
        [avatarImageView, usernameTextField, followButton, captionTextView, tagsTextView, likeButton, likeTextField, unLikeButton, unLikeTextField, commentButton, commentTextField, shareButton, shareTextField, remixButton, remixTextField, musicImageView].forEach {
            addSubview($0)
        }
    }
    
    func setupConstarints() {
        followButton.snp.makeConstraints {
            $0.width.equalTo(70.0)
            $0.height.equalTo(20.0)
            $0.left.equalTo(usernameTextField.snp.right).inset(-4.0)
            $0.centerY.equalTo(usernameTextField.snp.centerY)
        }
        usernameTextField.snp.makeConstraints {
            $0.left.equalTo(avatarImageView.snp.right).inset(-4.0)
            $0.centerY.equalTo(avatarImageView.snp.centerY)
        }
        avatarImageView.snp.makeConstraints {
            $0.left.equalTo(tagsTextView.snp.left)
            $0.bottom.equalTo(captionTextView.snp.top).inset(-8.0)
        }
        captionTextView.snp.makeConstraints {
            $0.width.equalTo(tagsTextView.snp.width)
            $0.left.equalTo(tagsTextView.snp.left)
            $0.bottom.equalTo(tagsTextView.snp.top).inset(-8.0)
        }
        tagsTextView.snp.makeConstraints {
            $0.width.equalTo(120.0)
            $0.left.equalToSuperview().inset(8.0)
            $0.bottom.equalToSuperview().inset(8.0)
        }
        likeButton.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(likeTextField.snp.top).inset(-4.0)
        }
        likeTextField.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(unLikeButton.snp.top).inset(-8.0)
        }
        unLikeButton.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(unLikeTextField.snp.top).inset(-4.0)
        }
        unLikeTextField.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(commentButton.snp.top).inset(-8.0)
        }
        commentButton.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(commentTextField.snp.top).inset(-4.0)
        }
        commentTextField.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(shareButton.snp.top).inset(-8.0)
        }
        shareButton.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(shareTextField.snp.top).inset(-4.0)
        }
        shareTextField.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(remixButton.snp.top).inset(-8.0)
        }
        remixButton.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(remixTextField.snp.top).inset(-4.0)
        }
        remixTextField.snp.makeConstraints {
            $0.centerX.equalTo(musicImageView.snp.centerX)
            $0.bottom.equalTo(musicImageView.snp.top).inset(-8.0)
        }
        musicImageView.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().inset(8.0)
        }
    }
    
    func createButton(imageName: String, target: Selector) -> UIButton {
        let button = UIButton()
        if let image = UIImage(named: imageName) {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 20.0, height: 20.0))
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
        [usernameTextField, likeTextField, unLikeTextField, commentTextField, shareTextField, remixTextField].forEach{
            $0.delegate = self
        }
    }
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        if let parentVC = self.parentViewController {
            parentVC.present(picker, animated: true)
        }
    }
    
    func showCrop(image: UIImage, crop: CropViewCroppingStyle) {
        let vc = CropViewController(croppingStyle: crop, image: image)
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
}

// MARK: - UITextViewDelegate
extension YouTubeView: UITextViewDelegate {
    
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

// MARK: - UITextFieldDelegate
extension YouTubeView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case likeTextField:
            likeTextField.text = "\(Int(likes))"
        case unLikeTextField:
            unLikeTextField.text = "\(Int(unLikes))"
        case commentTextField:
            commentTextField.text = "\(Int(comments))"
        case shareTextField:
            shareTextField.text = "\(Int(shareds))"
        case remixTextField:
            remixTextField.text = "\(Int(remixs))"
        case usernameTextField:
            usernameTextField.text = "@"
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
            let currentText = usernameTextField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if !newText.hasPrefix("@") {
                usernameTextField.text = "@" + newText
                return false
            }
            return range.location < 10
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
        case unLikeTextField:
            unLikes = number
            unLikeTextField.text = number.formatNumber()
        case commentTextField:
            comments = number
            commentTextField.text = number.formatNumber()
        case shareTextField:
            shareds = number
            shareTextField.text = number.formatNumber()
        case remixTextField:
            remixs = number
            remixTextField.text = number.formatNumber()
        default:
            return
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension YouTubeView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        isAvatarSelected ? showCrop(image: image, crop: .circular) : showCrop(image: image, crop: .default)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CropViewControllerDelegate
extension YouTubeView: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 26.0, height: 26.0))
        if isAvatarSelected == true {
            avatarImageView.image = resizedImage
        } else {
            musicImageView.image = resizedImage
        }
        cropViewController.dismiss(animated: true)
    }
}

// MARK: - Private Objc-C method's
@objc private extension YouTubeView {
    
    func followBTnTapped() {
        followButton.alpha = isFollowed ? 1.0 : 0.5
        isFollowed ? followButton.setTitle("Follow", for: .normal) : followButton.setTitle("Unfollow", for: .normal)
        isFollowed.toggle()
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
        likes += isLiked ?  -1 : 1
        likeButton.tintColor = isLiked ? .white : .systemBlue
        isLiked.toggle()
    }
    
    func unLikeBtnTapped() {
        unLikes += isUnLiked ?  -1 : 1
        unLikeButton.tintColor = isUnLiked ? .white : .systemBlue
        isUnLiked.toggle()
    }
    
    func commentBtnTapped() {
        comments += isCommented ?  -1 : 1
        commentButton.tintColor = isCommented ? .white : .systemBlue
        isCommented.toggle()
    }
    
    func shareBtnTapped() {
        shareds += isShared ?  -1 : 1
        shareButton.tintColor = isShared ? .white : .systemBlue
        isShared.toggle()
    }
    
    func remixBtnTapped() {
        remixs += isRemixed ?  -1 : 1
        remixButton.tintColor = isRemixed ? .white : .systemBlue
        isRemixed.toggle()
    }
    
    func hideKeyboard() {
        [likeTextField, unLikeTextField, commentTextField, shareTextField, remixTextField, captionTextView, tagsTextView, usernameTextField].forEach{
            $0.resignFirstResponder()
        }
    }
}
