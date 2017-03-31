//
//  GenerationTests.swift
//  GenerationTests
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import XCTest
@testable import MyNoise

class GenerationTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    override func setUp() {
        super.setUp()
        
        brownianUpperBound = 10
        brownianFeedback = 0
        brownianDamping = 5
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_brownianParameters_persistence() {
        brownianUpperBound = 1
        brownianFeedback = 2
        brownianDamping = 3
        
        XCTAssertEqual(brownianUpperBound, 1)
        XCTAssertEqual(brownianFeedback, 2)
        XCTAssertEqual(brownianDamping, 3)
    }
    
    func test_whiteNoise_generate() {
        var noise = generateWhiteNoise(count: 10)
        XCTAssertEqual(noise.count, 10, "Generated \(noise.count) (expected 10)")
        
        noise = generateWhiteNoise(count: 9)
        XCTAssertEqual(noise.count, 9, "Generated \(noise.count) (expected 9)")
        
        self.measure {
            _ = generateWhiteNoise(count: 1000000)
        }
    }
    
    func test_brownNoise_generate() {
        var noise = generateBrownNoise(count: 10)
        XCTAssertTrue(noise.count == 10, "Generated \(noise.count) (expected 10)")
        
        noise = generateBrownNoise(count: 9)
        XCTAssertTrue(noise.count == 9, "Generated \(noise.count) (expected 9)")
        
        self.measure {
            _ = generateBrownNoise(count: 1000000)
        }
    }
    
}
