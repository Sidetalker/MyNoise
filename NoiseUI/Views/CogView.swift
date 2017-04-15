//
//  CogView.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 4/15/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

protocol CogDelegate {
    func cogTapped(cog: CogView)
}

@IBDesignable
class CogView: UIView {
    
    public var delegate: CogDelegate?
    
    @IBInspectable public var themeString: String {
        get { return String(describing: theme) }
        set { theme = Theme(rawValue: newValue) ?? .blue }
    }
    
    var theme: Theme = .blue {
        didSet { setNeedsDisplay() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.cogTapped(cog: self)
    }

    override func draw(_ rect: CGRect) {
        switch theme {
        case .blue: NoisePaint.drawBlueCog(frame: rect)
        case .yellow: NoisePaint.drawYellowCog(frame: rect)
        case .red: NoisePaint.drawRedCog(frame: rect)
        case .purple: NoisePaint.drawPurpleCog(frame: rect)
        case .green: NoisePaint.drawGreenCog(frame: rect)
        }
    }
}
