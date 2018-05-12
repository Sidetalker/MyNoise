//
//  SettingsViewController.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 5/11/18.
//  Copyright © 2018 Kevin Sullivan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    var settingsTableVC: SettingsTableViewController?
    
    var theme = ThemeManager.shared.theme
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblHeader.textColor = theme.accentColor
        view.backgroundColor = theme.baseColor
        btnSave.setTitleColor(theme.accentColor, for: .normal)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueEmbedSettings" {
//            settingsTableVC = segue.destination as? SettingsTableViewController
//            settingsTableVC
//        }
//    }
    
    @IBAction func saveTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueSettingsUnwind", sender: self)
    }
    
    @IBAction func startOnLaunchToggled(_ sender: Any) {
    }
    
    @IBAction func noiseTypeSelected(_ sender: Any) {
    }
    
}
