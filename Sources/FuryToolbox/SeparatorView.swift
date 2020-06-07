//
//  SeparatorView.swift
//  
//
//  Created by Michael on 06/06/2020.
//

import Foundation
import UIKit

@IBDesignable
public class SeparatorView: UIView {

    static let scale: CGFloat = { 1.0 / UIScreen.main.nativeScale }()
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: SeparatorView.scale, height: SeparatorView.scale)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
