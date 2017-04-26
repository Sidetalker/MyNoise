//
//  AppDelegate.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyBeaver
import Bugsnag
import Fabric
import Answers

/// SwiftyBeaver logger, see `AppDelegate.configureLogging()` for configuration
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureAudio()
        configureLogging()
    
        return true
    }
    
    /// Set up SwiftyBeaver, Bugsnag, and Answers
    func configureLogging() {
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        
        console.minLevel = .debug
        file.format = "$J" // JSON output
        file.minLevel = .verbose
        
        log.addDestination(console)
        log.addDestination(file)
        
        Bugsnag.start(withApiKey: "16cb4cadc49caa0fbac6dace97a27cf4")
        
        Fabric.with([Answers.self])
    }
    
    /// Configure app for background audio
    func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            log.debug("Registered for background playback")
        } catch let error {
            log.error("Unable to set up app for background audio playback: \(error)")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

