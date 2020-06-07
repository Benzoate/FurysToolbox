//
//  NotificationBannerView.swift
//  
//
//  Created by Michael on 06/06/2020.
//

import Foundation
import UIKit

public class NotificationBannerView: UIView {
    
    public var gradientStartColor: UIColor = .systemRed {
        didSet {
            iconGradientChanged = true
            setNeedsLayout()
        }
    }
    
    public var gradientEndColor: UIColor = .systemYellow {
        didSet {
            iconGradientChanged = true
            setNeedsLayout()
        }
    }
    
    public var imageTint: UIColor {
        get { return iconImageView.tintColor }
        set { iconImageView.tintColor = newValue }
    }
    
    public var title: String = "" {
        didSet {
            textChanged = true
            setNeedsLayout()
        }
    }
    
    public var subtitle: String = "" {
        didSet {
            textChanged = true
            setNeedsLayout()
        }
    }
    
    public var titleFont: UIFont = .systemFont(ofSize: 14, weight: .medium) {
        didSet {
            textChanged = true
            setNeedsLayout()
        }
    }
    
    public var subtitleFont: UIFont = .systemFont(ofSize: 14, weight: .light) {
        didSet {
            textChanged = true
            setNeedsLayout()
        }
    }
    
    public var titleColor: UIColor = .secondaryLabel {
        didSet {
            textChanged = true
            setNeedsLayout()
        }
    }
    
    public var subtitleColor: UIColor = .secondaryLabel {
        didSet {
            textChanged = true
            setNeedsLayout()
        }
    }
    
    public var icon: UIImage? {
        get { return iconImageView.image }
        set { iconImageView.image = newValue }
    }
    
    public var tapHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        preservesSuperviewLayoutMargins = true

        iconImageBackingView.mask = iconBackingMask
        iconBackingMask.frame = iconImageBackingView.bounds
        backingView.mask = backingMask
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBanner(_:))))
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
       
        iconImageBackingView.layer.insertSublayer(iconGradientLayer, at: 0)
        
        swipeDownGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeToDismiss(_:)))
        addGestureRecognizer(swipeDownGesture!)
        
        
        addSubview(shadowView)
        addSubview(backingView)
        addSubview(iconImageBackingView)
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        let backingTopConstraint = backingView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        backingTopConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: backingView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: backingView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: backingView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: backingView.bottomAnchor),
            
            backingTopConstraint,
            backingView.heightAnchor.constraint(equalToConstant: 60),
            backingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: backingView.trailingAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: backingView.bottomAnchor, constant: 0),

            iconImageBackingView.heightAnchor.constraint(equalToConstant: 44),
            iconImageBackingView.widthAnchor.constraint(equalToConstant: 44),
            iconImageBackingView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            iconImageBackingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: iconImageBackingView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: iconImageBackingView.trailingAnchor),
            iconImageView.topAnchor.constraint(equalTo: iconImageBackingView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: iconImageBackingView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageBackingView.trailingAnchor, constant: 16),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if iconGradientChanged {
            iconGradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
            iconGradientChanged = false
        }
        
        if textChanged {
            updateTextLabel()
            textChanged = false
        }
        
        iconBackingMask.frame = iconImageBackingView.bounds
        backingMask.frame = backingView.bounds
        iconGradientLayer.frame = iconImageBackingView.bounds
    }
    
    @objc private func didTapBanner(_ sender: UITapGestureRecognizer?) {
        tapHandler?()
    }
    
    public func willBeDismissed() {
        swipeDownGesture?.isEnabled = false
    }
    
    private var swipeStartPoint: CGPoint?
    @objc
    func swipeToDismiss(_ gesture: UIPanGestureRecognizer) {

        let swipeStartPoint = self.swipeStartPoint ?? .zero
        let currentLocation = gesture.location(in: self.window)
        let dY = currentLocation.y - swipeStartPoint.y
        let velocity = gesture.velocity(in: self).y
        switch gesture.state {
        case .began:
            self.swipeStartPoint = currentLocation
            break
        case .changed:
            if dY < 0 {
                transform = CGAffineTransform.identity.translatedBy(x: 0, y: tanh(-dY / 100.0) * -100)
            } else {
                transform = CGAffineTransform.identity.translatedBy(x: 0, y: dY)
            }
            break
        case .ended:
            if dY < 50 && velocity < 200 {
                UIView.animate(withDuration: 0.5, delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0,
                               options: [.allowUserInteraction, .beginFromCurrentState],
                               animations: {
                    self.transform = .identity
                }, completion: nil)
            } else {
                if velocity > 2 * bounds.size.height {
                    UIView.animate(withDuration: 1) {
                        self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: velocity + dY)
                    }
                } else {
                    UIView.animate(withDuration: 0.26) {
                        self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: UIScreen.main.bounds.maxY - ((self.window?.convert(self.bounds.origin, from: self) ?? CGPoint.zero).y - dY))
                    }
                }
            }
        default:
            break
        }
    }
    
    private func updateTextLabel() {
        let result = NSMutableAttributedString(string: "")
        let hasTitle = title.isEmpty == false
        let hasSubtitle = title.isEmpty == false
        
        if hasTitle {
            result.append(NSAttributedString(string: title, attributes: [.font: titleFont, .foregroundColor: titleColor]))
            if hasSubtitle {
                result.append(NSAttributedString(string: "\n", attributes: [.font: titleFont]))
            }
        }
        
        if hasSubtitle {
            result.append(NSAttributedString(string: subtitle, attributes: [.font: subtitleFont, .foregroundColor: subtitleColor]))
        }
        titleLabel.attributedText = result
    }

    private let backingView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let iconImageBackingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        view.backgroundColor = .clear
        return view
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let iconBackingMask: RoundedRectangleView = {
        let view = RoundedRectangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 8
        return view
    }()
    
    private let backingMask: RoundedRectangleView = {
        let view = RoundedRectangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 8
        return view
    }()
    
    private lazy var iconGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        
        gradient.frame = iconImageBackingView.bounds
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient
    }()
    
    private var swipeDownGesture: UIPanGestureRecognizer?
    
    private var iconGradientChanged: Bool = true
    private var textChanged: Bool = true
}
