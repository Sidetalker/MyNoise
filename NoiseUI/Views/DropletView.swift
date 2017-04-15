//
//  DropletView.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 4/15/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

protocol DropletDelegate {
    func dropletTapped(droplet: DropletView)
}

@IBDesignable
class DropletView: UIView {
    
    public var delegate: DropletDelegate?
    
    @IBInspectable public var themeString: String {
        get { return String(describing: theme) }
        set { theme = Theme(rawValue: newValue) ?? .blue }
    }
    
    @IBInspectable public var hasBadge: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var badgeScaleFactor: CGFloat = 0.8 {
        didSet { setNeedsDisplay() }
    }
    
    public var theme: Theme = .blue {
        didSet { setNeedsDisplay() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.dropletTapped(droplet: self)
    }
    
    override func draw(_ rect: CGRect) {
        let inset = rect.width - (rect.width * badgeScaleFactor)
        let frame = rect.insetBy(dx: hasBadge ? inset : 0, dy: hasBadge ? inset : 0)
        
        if hasBadge {
            switch theme {
            case .blue: NoisePaint.drawBlueBadge(frame: rect)
            case .yellow: NoisePaint.drawYellowBadge(frame: rect)
            case .red: NoisePaint.drawRedBadge(frame: rect)
            case .purple: NoisePaint.drawPurpleBadge(frame: rect)
            case .green: NoisePaint.drawGreenBadge(frame: rect)
            }
        }
        
        switch theme {
        case .blue: NoisePaint.drawBlueDrop(frame: frame)
        case .yellow: NoisePaint.drawYellowDrop(frame: frame)
        case .red: NoisePaint.drawRedDrop(frame: frame)
        case .purple: NoisePaint.drawPurpleDrop(frame: frame)
        case .green: NoisePaint.drawGreenDrop(frame: frame)
        }
    }
}
