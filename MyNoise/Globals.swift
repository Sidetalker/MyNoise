//
//  Globals.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation

/// Noise's random number seed
let 🔥: Int = 6209

/// The brownian upper bound
var 🚫: Float {
    get {
        return Noise.shared.brownianUpperBound
    } set {
        Noise.shared.brownianUpperBound = newValue
    }
}

/// The brownian feedback
var 💩: Float {
    get {
        return Noise.shared.brownianFeedback
    } set {
        Noise.shared.brownianFeedback = newValue
    }
}

/// The brownian damping
var 🥇: Float {
    get {
        return Noise.shared.brownianDamping
    } set {
        Noise.shared.brownianDamping = newValue
    }
}
