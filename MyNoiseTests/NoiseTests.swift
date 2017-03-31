//
//  NoiseTests.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 3/7/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import XCTest
@testable import MyNoise

// Hardcode the one OSStatus we need to avoid importing AudioToolbox
let kAudioComponentErr_NotPermitted: OSStatus = -66748

class NoiseTests: XCTestCase {
    
    // MARK: - Setup/Teardown
    
    override class func setUp() {
        super.setUp()
        _ = Noise.shared // Initialize the singleton
        sleep(3) // Let our nitpicky AudioUnit cool down
    }
    
    override func setUp() {
        super.setUp()
        
        sleep(3) // Make sure we don't unsafely tear down music
        Noise.stop()
        XCTAssertFalse(Noise.shared.isPlaying)
        sleep(3)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Helper functions
    
    func startNoise() {
        let result = Noise.start()
        XCTAssertEqual(result, noErr)
        XCTAssertTrue(Noise.shared.isPlaying)
    }
    
    // Tests
    
    func test_noise_start() {
        startNoise()
    }
    
    func test_noise_instantStop() {
        startNoise()
        
        let result: OSStatus = Noise.stop()
        XCTAssertEqual(result, kAudioComponentErr_NotPermitted) // Toggled too quick, expect error
        XCTAssertTrue(Noise.shared.isPlaying)
    }
    
    func test_noise_delayedStop() {
        startNoise()
        sleep(3)
        
        Noise.stop()
        XCTAssertFalse(Noise.shared.isPlaying)
    }
    
    func test_noise_delayedToggle() {
        startNoise()
        sleep(3)
        
        Noise.toggle()
        XCTAssertFalse(Noise.shared.isPlaying)
        sleep(3)
        
        Noise.toggle()
        XCTAssertTrue(Noise.shared.isPlaying)
    }
    
    func test_noise_interruption() {
        Noise.handleInterruption()
        XCTAssertFalse(Noise.shared.isPlaying)
        
        startNoise()
        sleep(3)
        
        Noise.handleInterruption()
        XCTAssertFalse(Noise.shared.isPlaying)
    }
    
}
