//
//  ThemeManager.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 5/11/18.
//  Copyright © 2018 Kevin Sullivan. All rights reserved.
//

import UIKit
import NoiseUI

class ThemeManager {
    /// Singleton accessor
    public static let shared = ThemeManager()
    var theme: Theme = .blue
}
