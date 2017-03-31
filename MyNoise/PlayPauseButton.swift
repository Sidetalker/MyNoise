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
    func playPauseButton(_ button: PlayPauseButton, willChangeState state: PlayPauseButtonState)
    
    /**
     The button has finished an animated state transition
     
     - parameter button: the PlayPauseButton that was animated
     - parameter to: the final state of the button
     */
    func playPauseButton(_ button: PlayPauseButton, didChangeState state: PlayPauseButtonState)
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
    @IBInspectable private(set) var stateName: String? {
        get {
            return String(describing: currentState)
        }
        set {
            if let state = PlayPauseButtonState(rawValue: newValue?.lowercased() ?? "") {
                internalState = state
            }
        }
    }
    
    /// The color of the button
    @IBInspectable public var color: UIColor = .black
    
    /// The internal state used to draw the button
    private var internalState: PlayPauseButtonState = .play {
        didSet { setNeedsDisplay() }
    }
    
    /// The current state, changed immediately when the button is tapped
    private(set) var currentState: PlayPauseButtonState = .play
    
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
        addTarget(self, action: #selector(PlayPauseButton.buttonTapped), for: .touchDown)
    }
    
    override public func draw(_ rect: CGRect) {
        switch internalState {
        case .play: NoisePaint.drawPlay(frame: rect, buttonFill: color)
        case .pause: NoisePaint.drawPause(frame: rect, buttonFill: color)
        }
    }
    
    /**
     Triggered on .touchDown
     
     - note: `@objc` attribute is needed for private/fileprivate target actions
    */
    @objc private func buttonTapped() {
        // The publicly visible state will be changed immediately
        currentState = !currentState
        
        delegate?.playPauseButton(self, willChangeState: currentState)
        
        // Wow that was fast, all done
        internalState = currentState
        
        delegate?.playPauseButton(self, didChangeState: internalState)
    }
}
