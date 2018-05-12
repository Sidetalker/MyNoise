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
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
    }
    
    func applyTheme() {
        theme = ThemeManager.shared.theme
        
        lblHeader.textColor = theme.accentColor
        view.backgroundColor = theme.baseColor
        btnSave.setTitleColor(theme.accentColor, for: .normal)
        
        settingsTableVC?.swtStartOnLaunch.onTintColor = theme.accentColor
        settingsTableVC?.swtStartOnLaunch.tintColor = theme.accentColor
        settingsTableVC?.swtStartOnLaunch.thumbTintColor = theme.baseColor
        settingsTableVC?.segNoiseType.tintColor = theme.accentColor
        
        let font = UIFont(name: "Handwritten", size: 30)!
        settingsTableVC?.segNoiseType.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEmbedSettings" {
            settingsTableVC = segue.destination as? SettingsTableViewController
            _ = settingsTableVC?.view
            applyTheme()
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueSettingsUnwind", sender: self)
    }
    
    @IBAction func startOnLaunchToggled(_ sender: Any) {
    }
    
    @IBAction func noiseTypeSelected(_ sender: Any) {
    }
    
}
