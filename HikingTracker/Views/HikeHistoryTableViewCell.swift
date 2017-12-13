//
//  HikeHistoryTableViewCell.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/12/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class HikeHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var hikeNameLabel: UILabel!
    
    @IBOutlet weak var hikeDateLabel: UILabel!
    @IBOutlet weak var hikeDistanceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
