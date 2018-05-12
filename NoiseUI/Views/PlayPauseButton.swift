//
//  PlayPauseButton.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/19/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

/// Turns .play to .pause and visa versa
prefix fileprivate func !(state: PlayPauseButtonState) -> PlayPauseButtonState {
    return state == .play ? .pause : .play
}

/// Provides potential button states
public enum PlayPauseButtonState: String {
    case play, pause
}

/// Provides button transition delegate events for `PlayPauseButton`
public protocol PlayPauseButtonDelegate {
    /**
     The button has been tapped and an animated transition to the target state has begun
     
     - parameter button: the PlayPauseButton tapped
     - parameter to: the target state for the animation
    */
    func playPauseButton(_ button: PlayPauseButton, updatedTo state: PlayPauseButtonState)
}

/**
 This is a Swifty way of implementing an optional protocol method. The other
 method, using `@objc` decorators, limits us to a class that can be represented 
 in Obj-C preventing the use of Swift types: http://www.avanderlee.com/swift-2-0/optional-protocol-methods/
 */
public extension PlayPauseButtonDelegate {
    func playPauseButton(_ button: PlayPauseButton, didChangeState state: PlayPauseButtonState) { }
}

@IBDesignable
public class PlayPauseButton: UIControl {
    /// The current state's string representation
    @IBInspectable var stateName: String? {
        get { return String(describing: displayState) }
        set { displayState = PlayPauseButtonState(rawValue: newValue ?? "") ?? .play }
    }
    
    @IBInspectable var themeString: String {
        get { return String(describing: theme) }
        set { theme = Theme(rawValue: newValue) ?? .blue }
    }
    
    public var theme: Theme = .blue {
        didSet { setNeedsDisplay() }
    }
    
    /// The state used to draw the button
    public var displayState: PlayPauseButtonState = .play {
        didSet { setNeedsDisplay() }
    }
    
    /// Delegate providing button transition events
    public var delegate: PlayPauseButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        addTarget(self, action: #selector(PlayPauseButton.buttonTapped), for: .touchDown)
    }
    
    override public func draw(_ rect: CGRect) {
        switch (displayState, theme) {
        case (.play, .blue): NoisePaint.drawBluePlay(frame: rect)
        case (.play, .yellow): NoisePaint.drawYellowPlay(frame: rect)
        case (.play, .red): NoisePaint.drawRedPlay(frame: rect)
        case (.play, .purple): NoisePaint.drawPurplePlay(frame: rect)
        case (.play, .green): NoisePaint.drawGreenPlay(frame: rect)
        case (.pause, .blue): NoisePaint.drawBluePause(frame: rect)
        case (.pause, .yellow): NoisePaint.drawYellowPause(frame: rect)
        case (.pause, .red): NoisePaint.drawRedPause(frame: rect)
        case (.pause, .purple): NoisePaint.drawPurplePause(frame: rect)
        case (.pause, .green): NoisePaint.drawGreenPause(frame: rect)
        }
    }
    
    /**
     Triggered on .touchDown
      
     - note: `@objc` attribute is needed for private/fileprivate target actions
    */
    @objc private func buttonTapped() {
        guard isEnabled else { return }
        
        displayState = !displayState
        delegate?.playPauseButton(self, updatedTo: displayState)
    }
}
