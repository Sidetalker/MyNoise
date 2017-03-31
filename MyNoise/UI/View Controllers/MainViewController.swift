//
//  MainViewController.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import NoiseUI

class MainViewController: UIViewController, PlayPauseButtonDelegate {
    
    @IBOutlet weak var playButton: PlayPauseButton! {
        didSet {
            playButton.delegate = self
        }
    }
    
    /// True if noise is currently playing
    var isPlaying = false
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func playPauseButton(_ button: PlayPauseButton, willChangeState state: PlayPauseButtonState) {
        isPlaying = !isPlaying
        
        if isPlaying {
            Noise.start()
        } else {
            Noise.stop()
        }
    }
}



