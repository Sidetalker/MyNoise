//
//  SettingsTableViewController.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 5/12/18.
//  Copyright © 2018 Kevin Sullivan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var lblStartOnLaunch: UILabel!
    @IBOutlet weak var swtStartOnLaunch: UISwitch!
    @IBOutlet weak var segNoiseType: UISegmentedControl!
    
    var theme = ThemeManager.shared.theme

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = theme.baseColor
        tableView.separatorColor = theme.accentColor
        lblStartOnLaunch.textColor = theme.accentColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = theme.baseColor
        cell.backgroundColor = theme.baseColor
    }
}
