//
//  Theme.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 4/15/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

public enum Theme: String {
    case blue, yellow, red, purple, green
    
    public var baseColor: UIColor {
        switch self {
        case .blue: return NoisePaint.blueBase
        case .green: return NoisePaint.greenBase
        case .yellow: return NoisePaint.yellowBase
        case .red: return NoisePaint.redBase
        case .purple: return NoisePaint.purpleBase
        }
    }
    
    public var accentColor: UIColor {
        switch self {
        case .blue: return NoisePaint.blueAccent
        case .green: return NoisePaint.greenAccent
        case .yellow: return NoisePaint.yellowAccent
        case .red: return NoisePaint.redAccent
        case .purple: return NoisePaint.purpleAccent
        }
    }
}
