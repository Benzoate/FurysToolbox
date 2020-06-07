//
//  RoundedImageView.swift
//  
//
//  Created by Michael on 06/06/2020.
//

import Foundation
import UIKit

@IBDesignable
public class RoundedImageView: UIImageView {
    
    private let maskRectangle: RoundedRectangleView = {
        let view = RoundedRectangleView()
        view.backgroundColor = .clear
        view.cornerRadius = 6
        return view
    }()
    
    @IBInspectable
    public var cornerRadius: CGFloat = 8 {
        didSet {
            maskRectangle.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    public var fillColor: UIColor {
        get { return maskRectangle.fillColor }
        set { maskRectangle.fillColor = newValue}
    }
    
    public var corners: UIRectCorner {
        get { return maskRectangle.corners }
        set { maskRectangle.corners = newValue }
    }
    
    @IBInspectable
    public var topLeft: Bool {
        get { return corners.contains(.topLeft) }
        set {
            if newValue {
                corners.formUnion(.topLeft)
            } else {
                corners.remove(.topLeft)
            }
        }
    }
    
    @IBInspectable
    public var topRight: Bool {
        get { return corners.contains(.topRight) }
        set {
            if newValue {
                corners.formUnion(.topRight)
            } else {
                corners.remove(.topRight)
            }
        }
    }
    
    @IBInspectable
    public var bottomLeft: Bool {
        get { return corners.contains(.bottomLeft) }
        set {
            if newValue {
                corners.formUnion(.bottomLeft)
            } else {
                corners.remove(.bottomLeft)
            }
        }
    }
    
    @IBInspectable
    public var bottomRight: Bool {
        get { return corners.contains(.bottomRight) }
        set {
            if newValue {
                corners.formUnion(.bottomRight)
            } else {
                corners.remove(.bottomRight)
            }
        }
    }
    
    override public func layoutSubviews() {
        if mask != maskRectangle {
            mask = maskRectangle
        }
        maskRectangle.frame = bounds
        if cornerRadius < 0 {
            maskRectangle.cornerRadius = min(bounds.height, bounds.width)
        }
        maskRectangle.layoutSubviews()
        super.layoutSubviews()
    }
}
