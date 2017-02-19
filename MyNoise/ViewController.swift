//
//  ViewController.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    var brownUnit: AudioComponentInstance? = nil
    
    var offset = 0
    
    var isPlaying = false {
        didSet {
            startButton.setTitle(isPlaying ? "Stop" : "Start", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        offset = Int(slider.value)
    }
    
    @IBAction func startTapped(_ sender: Any) {
        isPlaying = !isPlaying
        
        if isPlaying {
            Noise.start()
        } else {
            Noise.stop()
        }
    }
}



