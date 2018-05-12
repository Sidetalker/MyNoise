//
//  CustomSegues.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 5/11/18.
//  Copyright © 2018 Kevin Sullivan. All rights reserved.
//

import UIKit

class SlideTransitionSegue: UIStoryboardSegue {
    
    override func perform() {
        guard
            let sourceView = source.view,
            let destinationView = destination.view
        else {
            log.error("Missing \(source) or \(destination)")
            return
        }
        
        let window = UIApplication.shared.keyWindow
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        destination.view.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        
        window?.insertSubview(destination.view, aboveSubview: source.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            sourceView.frame = sourceView.frame.offsetBy(dx: 0, dy: -screenHeight)
            destinationView.frame = destinationView.frame.offsetBy(dx: 0, dy: -screenHeight)
        }) { _ in
            self.source.present(self.destination, animated: false)
        }
    }
}

class SlideTransitionSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        guard
            let sourceView = source.view,
            let destinationView = destination.view
        else {
            log.error("Missing \(source) or \(destination)")
            return
        }
        
        let window = UIApplication.shared.keyWindow
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        destination.view.frame = CGRect(x: 0, y: -screenHeight, width: screenWidth, height: screenHeight)
        
        window?.insertSubview(destination.view, aboveSubview: source.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            sourceView.frame = sourceView.frame.offsetBy(dx: 0, dy: screenHeight)
            destinationView.frame = destinationView.frame.offsetBy(dx: 0, dy: screenHeight)
        }) { _ in
            self.source.dismiss(animated: false)
        }
    }
}
