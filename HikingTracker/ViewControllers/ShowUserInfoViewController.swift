//
//  ShowUserInfoViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/29/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class ShowUserInfoViewController: UIViewController {
    
    // MARK: Enums
    
    // MARK: Constants
    private let user = StoredUser()
    
    // MARK: Variables
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    // MARK: Weak Vars
    
    // MARK: Public Variables
    
    // MARK: Private Variables
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user.name
        weightLabel.text = user.getWeightForDisplay()
        heightLabel.text = user.getHeightForDisplay()
        sexLabel.text = user.gender
        birthdateLabel.text = user.birthdate?.displayStringWithoutTime
    }
    
    // MARK: IBActions
    
}
