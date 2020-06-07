//
//  RoundedRectangleView.swift
//  
//
//  Created by Michael on 06/06/2020.
//

import Foundation
import UIKit

@IBDesignable
public class RoundedRectangleView: UIView {
    @IBInspectable
    public var cornerRadius: CGFloat = 0

    @IBInspectable
    public var fillColor: UIColor = .black

    public var corners: UIRectCorner = .allCorners
    
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
    
    override public class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let shapeLayer = self.layer as? CAShapeLayer {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: .init(width: cornerRadius, height: cornerRadius))
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = fillColor.cgColor
        }
    }
}
