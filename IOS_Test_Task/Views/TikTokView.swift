//
//  TikTokView.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 01.10.2024.
//

import UIKit
import SnapKit
import Photos

final class TikTokView: UIView {
    
    // MARK: - Private UI-Elements
    private let imageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 16.0
        //        $0.isHidden = true
        $0.layer.zPosition = 0
    }
    private let avatarImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 18.0
        $0.isHidden = false
        $0.layer.zPosition = 1
        
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
    private lazy var likeButton = UIButton().after{
        
        if let image = UIImage(named: "like") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            $0.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }
        $0.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
    }
    private let likeTextField = CountTextField().after {
        $0.text = "250,5k"
        $0.layer.zPosition = 1
    }
    private lazy var commentButton = UIButton().after{
        
        if let image = UIImage(named: "comment") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            $0.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }
        $0.addTarget(self, action: #selector(commentBtnTapped), for: .touchUpInside)
    }
    private let commentTextField = CountTextField().after {
        $0.text = "100k"
        $0.layer.zPosition = 1
    }
    private lazy var savedButton = UIButton().after{
        
        if let image = UIImage(named: "save") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            $0.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }
        $0.addTarget(self, action: #selector(savedBtnTapped), for: .touchUpInside)
    }
    private let savedTextField = CountTextField().after {
        $0.text = "89k"
        $0.layer.zPosition = 1
    }
    private lazy var repostButton = UIButton().after{
        
        if let image = UIImage(named: "repost") {
            let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 24.0, height: 24.0))
            $0.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }
        $0.addTarget(self, action: #selector(repostBtnTapped), for: .touchUpInside)
    }
    private let repostTextField = CountTextField().after {
        $0.text = "132,5k"
        $0.layer.zPosition = 1
    }
    private let musicImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 16.0
        $0.isHidden = false
        $0.layer.zPosition = 1
        
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
        $0.layer.zPosition = 1
    }
    private let captionTextField = UITextField().after {
        $0.text = "Caption of the post 😉"
        $0.font = UIFont(name: "Inter-Regular", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        $0.layer.zPosition = 1
    }
    private let tagsTextField = UITextField().after {
        $0.text = "#fyp"
        $0.font = UIFont(name: "Inter-SemiBold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        $0.layer.zPosition = 1
    }
    private let translateTextField = UITextField().after {
        $0.text = "Show translation"
        $0.font = UIFont(name: "Inter-Regular", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.layer.zPosition = 1
    }
    private let translateImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.isHidden = false
        $0.layer.zPosition = 1
        
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
        $0.layer.zPosition = 1
    }
    private let noteImageView = UIImageView().after {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.isHidden = false
        $0.layer.zPosition = 1
        
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
    
    func displayImage(_ image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        likeTextField.isHidden = false
    }
}

private extension TikTokView {
    
    func setupSubviews() {
        self.backgroundColor = UIColor(hex: "#18191b")
        [imageView, avatarImageView, likeButton, likeTextField, commentButton, commentTextField, savedButton, savedTextField, repostButton, repostTextField, musicImageView, translateTextField, usernameTextField, captionTextField, tagsTextField, translateImageView, songTextField, noteImageView].forEach {
            addSubview($0)
        }
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(282.0)
            $0.height.equalTo(416.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(36.0)
        }
        avatarImageView.snp.makeConstraints {
            $0.bottom.equalTo(likeButton.snp.top).inset(-16.0)
            $0.centerX.equalTo(musicImageView.snp.centerX)
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
            $0.bottom.equalTo(imageView.snp.bottom).inset(8.0)
            $0.right.equalTo(imageView.snp.right).inset(16.0)
        }
        usernameTextField.snp.makeConstraints {
            $0.bottom.equalTo(captionTextField.snp.top).inset(-8.0)
            $0.left.equalTo(translateImageView.snp.left)
        }
        captionTextField.snp.makeConstraints {
            $0.width.equalTo(tagsTextField.snp.width)
            $0.bottom.equalTo(tagsTextField.snp.top).inset(-8.0)
            $0.left.equalTo(translateImageView.snp.left)
        }
        tagsTextField.snp.makeConstraints {
            $0.width.equalTo(songTextField.snp.width)
            $0.bottom.equalTo(translateTextField.snp.top).inset(-8.0)
            $0.left.equalTo(translateImageView.snp.left)
        }
        translateTextField.snp.makeConstraints {
            $0.centerY.equalTo(translateImageView.snp.centerY)
            $0.left.equalTo(translateImageView.snp.right).inset(-8.0)
        }
        translateImageView.snp.makeConstraints {
            $0.bottom.equalTo(noteImageView.snp.top).inset(-8.0)
            $0.left.equalTo(imageView.snp.left).inset(16.0)
        }
        songTextField.snp.makeConstraints {
            $0.width.equalTo(120.0)
            $0.centerY.equalTo(noteImageView.snp.centerY)
            $0.left.equalTo(noteImageView.snp.right).inset(-8.0)
        }
        noteImageView.snp.makeConstraints {
            $0.bottom.equalTo(imageView.snp.bottom).inset(16.0)
            $0.left.equalTo(imageView.snp.left).inset(16.0)
        }
    }
    
    func setupTextFields() {
        [likeTextField, commentTextField, savedTextField, repostTextField, usernameTextField, captionTextField, tagsTextField, translateTextField, songTextField].forEach{
            $0.delegate = self
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tapGesture)
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        avatarImageView.isUserInteractionEnabled = true
    }
    
    func presentImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        vc.mediaTypes = ["public.image", "public.movie"]
        if let parentVC = self.parentViewController {
            parentVC.present(vc, animated: true, completion: nil)
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
        case tagsTextField:
            tagsTextField.text = "#"
        default:
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            
        case CountTextField():
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
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 24
            
        case captionTextField:
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 240
            
        case tagsTextField:
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            let tags = updatedText.components(separatedBy: " ").map { $0.trimmingCharacters(in: .whitespaces) }
            
            return tags.count <= 10
            
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TikTokView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            avatarImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Objc-C methods
@objc private extension TikTokView {
    
    func avatarTapped() {
        self.presentImagePicker()
    }
    
    func likeBtnTapped() {
        likeButton.tintColor = isLiked ? .white : .red
        isLiked.toggle()
    }
    
    func commentBtnTapped() {
        commentButton.tintColor = isCommented ? .white : .darkGray
        isCommented.toggle()
    }
    
    func savedBtnTapped() {
        savedButton.tintColor = isSaved ? .white : .yellow
        isSaved.toggle()
    }
    
    func repostBtnTapped() {
        repostButton.tintColor = isReposted ? .white : .darkGray
        isReposted.toggle()
    }
    
    func hideKeyboard() {
        [likeTextField, commentTextField, savedTextField, repostTextField, usernameTextField, captionTextField, tagsTextField, translateTextField, songTextField].forEach{
            $0.resignFirstResponder()
        }
    }
}
