//
//  Generators.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Darwin

/// Just an array of Floats, cause typealiases are _cool_
public typealias NoisePoints = [Float]

/**
 Generates brown noise from white noise using a random walk approximation to fractional
 Brownian motion where the increments of the fractional random walk are defined as a
 weighted sum of the past increments of the white noise random walk
 The weighted sum (💩) is maintained by the `Noise` singleton
 
 - note: [Research Paper](https://arxiv.org/pdf/0708.1905.pdf)
 - parameter white: The white noise `Float`
 */
fileprivate func getBrownNoise(from white: Float) -> Float {
    brownianFeedback += white
    
    // Wrap around upper and lower bounds
    if brownianFeedback < -brownianUpperBound {
        brownianFeedback = -brownianUpperBound - (brownianFeedback + brownianUpperBound)
    } else if brownianFeedback > brownianUpperBound {
        brownianFeedback = brownianUpperBound - (brownianFeedback - brownianUpperBound)
    }
    
    return brownianFeedback / brownianDamping
}

/**
 Generates brown noise points by approximating Brownian motion from white noise
 
 - parameter count: The number of points to be returned
 */
public func generateBrownNoise(count: Int) -> NoisePoints {
    var brownNoise = NoisePoints()
    
    for noise in generateWhiteNoise(count: count) {
        brownNoise.append(getBrownNoise(from: noise))
    }
    
    return brownNoise
}


/**
 Generates white noise points using the Box-Muller transform

 - parameter count: The number of points to be returned
 */
public func generateWhiteNoise(count: Int) -> NoisePoints {
    var whiteNoise = NoisePoints()
    
    while whiteNoise.count < count - 1 {
        let a = drand48()
        let b = drand48()
        
        // Box-Muller transform
        let x = sqrt(-2 * Darwin.log(a)) * sin(2 * .pi * b)
        let y = sqrt(-2 * Darwin.log(b)) * cos(2 * .pi * a)
        
        whiteNoise.append(Float(x))
        whiteNoise.append(Float(y))
    }
    
    if whiteNoise.count < count {
        whiteNoise.append(Float(drand48()))
    }
    
    return whiteNoise
}
