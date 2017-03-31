//
//  MyNoiseUITests.swift
//  MyNoiseUITests
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import XCTest

class MyNoiseUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_playPause_toggle() {
        // Just toggle play/pause, revisit for validation options
        let playPause = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        
        playPause.tap()
        sleep(3)
        playPause.tap()
    }
    
}
