//
//  DateStampView.swift
//  
//
//  Created by Michael on 13/06/2020.
//

import Foundation
import UIKit

public class DateStampView: UIView {
    public var date: Date? {
        didSet {
            updateDate()
        }
    }
    
    public var color: UIColor = .systemRed {
        didSet {
            updateColors()
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public init() {
        super.init(frame: .init(x: 100, y: 100, width: 28, height: 28))
        commonInit()
    }
    
    private func commonInit() {
        layer.addSublayer(innerFillLayer)
        layer.addSublayer(monthLayer)
        layer.addSublayer(dayLayer)
        
        updateColors()
        updateDate()
    }
    
    private var shapeLayer: CAShapeLayer { return layer as! CAShapeLayer }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius: CGFloat = 6
        shapeLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        let monthStart = bounds.height * 0.6
        innerFillLayer.frame = CGRect(x: 1.2, y: 1.2, width: bounds.width - 2.4, height: monthStart)
        let innerRadius = cornerRadius * (innerFillLayer.bounds.width / shapeLayer.bounds.width)
        innerFillLayer.path = UIBezierPath(roundedRect: innerFillLayer.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: innerRadius, height: innerRadius)).cgPath
        
        let daySize = self.daySize
        let monthSize = self.monthSize
        
        let monthHeight = (bounds.height - monthStart) - 2
        monthLayer.frame = CGRect(x: 0,
                                  y: (1 + monthStart) + (monthHeight - monthSize * 1.2) * 0.5,
                                  width: bounds.width,
                                  height: monthSize * 1.2)
        let dayHeight = monthStart - 2
        dayLayer.frame = CGRect(x: 1,
                                y: 1 + (dayHeight - daySize) * 0.5,
                                width: bounds.width - 2,
                                height: daySize)
        
        dayLayer.fontSize = daySize
        monthLayer.fontSize = monthSize
    }
    
    override public class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    private func updateColors() {
        dayLayer.foregroundColor = color.cgColor
        shapeLayer.fillColor = color.cgColor
    }
    
    private func updateDate() {
        guard let date = date else {
            dayLayer.string = ""
            monthLayer.string = ""
            accessibilityLabel = "No date"
            return
        }
        
        formatter.dateFormat = "dd"
        dayLayer.string = formatter.string(from: date)

        formatter.dateFormat = "MMM"
        monthLayer.string = formatter.string(from: date)
        
        formatter.dateStyle = .medium
        accessibilityLabel = formatter.string(from: date)
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .autoupdatingCurrent
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let innerFillLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    private let monthLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.foregroundColor = UIColor.white.cgColor
        layer.string = ""
        let font = CGFont(UIFont.systemFont(ofSize: 8, weight: .regular).fontName as CFString)
        layer.font = font
        layer.fontSize = 8
        layer.alignmentMode = .center
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    
    
    private let dayLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.string = ""
        let font = CGFont(UIFont.systemFont(ofSize: 16, weight: .semibold).fontName as CFString)
        layer.font = font
        layer.fontSize = 16
        layer.alignmentMode = .center
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    
    private var sizeScale: CGFloat {
        return min(frame.width, frame.height) / 32
    }
    
    private var daySize: CGFloat {
        return sizeScale * 16
    }
    
    private var monthSize: CGFloat {
        return sizeScale * 9
    }
}
