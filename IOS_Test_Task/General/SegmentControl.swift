//
//  SegmentControl.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 08.10.2024.
//

import UIKit
import KeychainAccess

class SegmentedControl: UIView {
    
    //MARK: - Delegate
    weak var delegate: SegmentedControlDelegate?
    
    //MARK: - Properties
    var stackView: UIStackView = UIStackView()
    var buttonsCollection: [UIButton] = []
    var currentIndexView: UIView = UIView(frame: .zero)
    var isSubscribed: Bool = false 
    
    var buttonPadding: CGFloat = 8.0
    var stackViewSpacing: CGFloat = 0
    
    //MARK: - Callback
    var didTapSegment: ((Int) -> ())?
    
    //MARK: - Inspectable Properties
    @IBInspectable var currentIndex: Int = 0 {
        didSet {
            setCurrentIndex()
        }
    }
    
    @IBInspectable var currentIndexTitleColor: UIColor = .white {
        didSet {
            updateTextColors()
        }
    }
    
    @IBInspectable var currentIndexBackgroundColor: UIColor = UIColor(hex: "#33343A") {
        didSet {
            setCurrentViewBackgroundColor()
        }
    }
    
    @IBInspectable var otherIndexTitleColor: UIColor = .gray {
        didSet {
            updateTextColors()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 12.0 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 10 {
        didSet {
            setButtonCornerRadius()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(hex: "#33343A") {
        didSet {
            setBorderColor()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            setBorderWidth()
        }
    }
    
    @IBInspectable var numberOfSegments: Int = 3 {
        didSet {
            addSegments()
        }
    }
    
    @IBInspectable var segmentsTitle: String = "Standart,HD,4K" {
        didSet {
            updateSegmentTitles()
        }
    }

    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCurrentIndex()
    }
    
    //MARK: - Functions
    private func commonInit() {
        backgroundColor = .clear
        setupStackView()
        addSegments()
        setCurrentIndexView()
        setCurrentIndex(animated: false)
        
        setCornerRadius()
        setButtonCornerRadius()
        setBorderColor()
        setBorderWidth()
    }
    
    private func setCurrentIndexView() {
        setCurrentViewBackgroundColor()
        addSubview(currentIndexView)
        sendSubviewToBack(currentIndexView)
    }
    
    private func setCurrentIndex(animated: Bool = true) {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(numberOfSegments)
                
                if animated {
                    UIView.animate(withDuration: 0.3) {
                        self.currentIndexView.frame =
                            CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                                   y: self.buttonPadding,
                                   width: buttonWidth,
                                   height: self.frame.height - (self.buttonPadding * 2))
                    }
                } else {
                    self.currentIndexView.frame =
                        CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                               y: self.buttonPadding,
                               width: buttonWidth,
                               height: self.frame.height - (self.buttonPadding * 2))
                }
                
                button?.configuration?.baseForegroundColor = currentIndexTitleColor
            } else {
                button?.configuration?.baseForegroundColor = otherIndexTitleColor
            }
        }
    }
    
    private func updateTextColors() {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                button?.configuration?.baseForegroundColor = .red
            } else {
                button?.configuration?.baseForegroundColor = .red
            }
        }
    }
    
    private func setCurrentViewBackgroundColor() {
        currentIndexView.backgroundColor = currentIndexBackgroundColor
    }
    
    private func setupStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonPadding),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonPadding),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: buttonPadding),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonPadding)
            ]
        )
    }
    
    private func addSegments() {
        buttonsCollection.removeAll()
        stackView.subviews.forEach { view in
            (view as? UIButton)?.removeFromSuperview()
        }

        let titles = segmentsTitle.split(separator: ",")
        
        for index in 0 ..< numberOfSegments {
            let button = UIButton()
            button.tag = index
            
            if titles.indices.contains(index) {
                let title = String(titles[index])
                button.setTitle(title, for: .normal)
            } else {
                button.setTitle("<Segment>", for: .normal)
            }
            
            button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16.0)
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)

            updateButtonImage(button: button, index: index)
            
            stackView.addArrangedSubview(button)
            buttonsCollection.append(button)
        }
    }
    
    private func updateButtonImage(button: UIButton, index: Int) {
        if index == 0 {
            button.setImage(nil, for: .normal)
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .clear
            button.configuration = configuration
        } else {
            if isSubscribed {
                button.setImage(nil, for: .normal)
                button.configuration?.image = nil
            } else {
                if let image = UIImage(named: "PRO") {
                    let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 36.0, height: 36.0))
                    button.setImage(resizedImage, for: .normal)
                    button.semanticContentAttribute = .forceRightToLeft
                    var configuration = UIButton.Configuration.filled()
                    var container = AttributeContainer()
                    container.font = UIFont(name: "Inter-SemiBold", size: 16.0)
                    configuration.attributedTitle = AttributedString(button.currentTitle ?? "", attributes: container)
                    configuration.imagePadding = 10
                    configuration.baseBackgroundColor = .clear
                    button.configuration = configuration
                }
            }
        }
    }
    
    private func updateSegmentTitles() {
        let titles = segmentsTitle.split(separator: ",")
        
        stackView.subviews.enumerated().forEach { (index, view) in
            if titles.indices.contains(index) {
                (view as? UIButton)?.setTitle(String(titles[index]), for: .normal)
            } else {
                (view as? UIButton)?.setTitle("<Segment>", for: .normal)
            }
        }
    }

    private func setCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func setButtonCornerRadius() {
        stackView.subviews.forEach { view in
            (view as? UIButton)?.layer.cornerRadius = buttonCornerRadius
        }
        
        currentIndexView.layer.cornerRadius = cornerRadius
    }
    
    private func setBorderColor() {
        layer.borderColor = borderColor.cgColor
    }
    
    private func setBorderWidth() {
        layer.borderWidth = borderWidth
    }
    
    //MARK: - IBActions
    @objc func segmentTapped(_ sender: UIButton) {
        if !isSubscribed && (sender.tag == 1 || sender.tag == 2) {
            delegate?.updateTrialMode(5)
        } else {
            didTapSegment?(sender.tag)
            currentIndex = sender.tag
        }
    }
    
    func updateSubscriptionStatus(isSubscribed: Bool) {
        self.isSubscribed = isSubscribed
        buttonsCollection.enumerated().forEach { (index, button) in
            updateButtonImage(button: button, index: index)
        }
    }
}
