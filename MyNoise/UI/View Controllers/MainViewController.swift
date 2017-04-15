//
//  MainViewController.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import NoiseUI

class MainViewController: UIViewController, PlayPauseButtonDelegate, DropletDelegate, CogDelegate {

    @IBOutlet weak var playButton: PlayPauseButton! {
        didSet { playButton.delegate = self }
    }
    
    @IBOutlet weak var droplet: DropletView! {
        didSet { droplet.delegate = self }
    }
    
    @IBOutlet weak var cog: CogView! {
        didSet { cog.delegate = self }
    }
    
    @IBOutlet weak var themeTitle: NameView!
    
    var theme: Theme = .blue {
        didSet {
            playButton.theme = theme
            droplet.theme = theme
            cog.theme = theme
            themeTitle.theme = theme
            view.backgroundColor = theme.baseColor
        }
    }
    
    var themes: [Theme] = [.blue, .red, .green, .yellow, .purple]
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()
        theme = .blue
    }
    
    func playPauseButton(_ button: PlayPauseButton, willChangeState state: PlayPauseButtonState) {
        switch state {
        case .play: Noise.stop()
        case .pause: Noise.start()
        }
    }
    
    func cogTapped(cog: CogView) {
        return
    }
    
    func dropletTapped(droplet: DropletView) {
        guard let nextTheme = themes.popLast() else {
            log.error("What?! You're supposed to be keeping me full!")
            return
        }
        
        themes.insert(nextTheme, at: 0)
        theme = nextTheme
    }
}



