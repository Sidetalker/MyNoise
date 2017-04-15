//
//  NameView.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 4/15/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

@IBDesignable
class NameView: UIView {
    
    @IBInspectable public var themeString: String {
        get { return String(describing: theme) }
        set { theme = Theme(rawValue: newValue) ?? .blue }
    }
    
    var theme: Theme = .blue {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        switch theme {
        case .blue: NoisePaint.drawBlueText(frame: rect)
        case .yellow: NoisePaint.drawYellowText(frame: rect)
        case .red: NoisePaint.drawRedText(frame: rect)
        case .purple: NoisePaint.drawPurpleText(frame: rect)
        case .green: NoisePaint.drawGreenText(frame: rect)
        }
    }
}
