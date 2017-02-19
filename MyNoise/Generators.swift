//
//  Generators.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation

/// Just an array of Floats, cause typealiases are _cool_
public typealias NoisePoints = [Float]

/**
 Generates brown noise from white noise by roughly approximating its integral
 using the `Noise` singleton to maintain a feedback buffer (💩)
 
 - parameter white: The white noise `Float`
 */
fileprivate func getBrownNoise(from white: Float) -> Float {
    💩 += white
    
    if 💩 < -🚫 {
        💩 = -🚫 - (💩 + 🚫)
    } else if 💩 > 🚫 {
        💩 = 🚫 - (💩 - 🚫)
    }
    
    return 💩 / 🥇
}

/**
 Generates brown noise points using the Box-Muller transform
 
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
        let x = sqrt(-2 * log(a)) * sin(2 * M_PI * b)
        let y = sqrt(-2 * log(a)) * cos(2 * M_PI * b)
        
        whiteNoise.append(Float(x))
        whiteNoise.append(Float(y))
    }
    
    if whiteNoise.count < count {
        whiteNoise.append(Float(drand48()))
    }
    
    return whiteNoise
}
