//
//  NoiseUITests.swift
//  NoiseUITests
//
//  Created by Kevin Sullivan on 2/19/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import XCTest
@testable import NoiseUI

class NoiseUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_painting() {
        NoisePaint.drawPlay()
        NoisePaint.drawPause()
    }
    
    func test_playPauseButton() {
        var button = PlayPauseButton(frame: .zero)
    }
    
}
