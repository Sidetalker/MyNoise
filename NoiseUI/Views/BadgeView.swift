//
//  BadgeView.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 4/15/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

@IBDesignable
class BadgeView: UIView {
    
    @IBInspectable public var themeString: String {
        get { return String(describing: theme) }
        set { theme = Theme(rawValue: newValue) ?? .blue }
    }
    
    var theme: Theme = .blue {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        switch theme {
        case .blue: NoisePaint.drawBlueBadge(frame: rect)
        case .yellow: NoisePaint.drawYellowBadge(frame: rect)
        case .red: NoisePaint.drawRedBadge(frame: rect)
        case .purple: NoisePaint.drawPurpleBadge(frame: rect)
        case .green: NoisePaint.drawGreenBadge(frame: rect)
        }
    }
}
