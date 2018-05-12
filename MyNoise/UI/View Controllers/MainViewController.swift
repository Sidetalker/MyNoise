//
//  MainViewController.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import NoiseUI
import MediaPlayer

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
            ThemeManager.shared.theme = theme
            
            playButton.theme = theme
            droplet.theme = theme
            cog.theme = theme
            themeTitle.theme = theme
            view.backgroundColor = theme.baseColor
        }
    }
    
    var themes: [Theme] = [.blue, .red, .green, .yellow, .purple]
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = .blue
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { remoteEvent in
            self.playButton.displayState = .pause
            Noise.start()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { remoteEvent in
            self.playButton.displayState = .play
            Noise.stop()
            return .success
        }
    }
    
    func playPauseButton(_ button: PlayPauseButton, updatedTo state: PlayPauseButtonState) {
        switch state {
        case .play: Noise.stop()
        case .pause: Noise.start()
        }
    }
    
    func cogTapped(cog: CogView) {
        performSegue(withIdentifier: "segueSettings", sender: self)
    }
    
    func dropletTapped(droplet: DropletView) {
        guard let nextTheme = themes.popLast() else {
            log.error("What?! You're supposed to be keeping me full!")
            return
        }
        
        themes.insert(nextTheme, at: 0)
        theme = nextTheme
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        
    }
}


