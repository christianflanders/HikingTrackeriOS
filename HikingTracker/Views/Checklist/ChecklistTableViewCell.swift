//
//  ChecklistTableViewCell.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/13/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import M13Checkbox

class ChecklistTableViewCell: UITableViewCell {

    @IBOutlet weak var checkListItemLabel: UILabel!

    var delegate: ChecklistButtonFlippedDelegate?
    var index: Int?

    @IBOutlet weak var checkBox: M13Checkbox!

    var checklistItemToDisplay: ChecklistItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//
//        // The color of the checkmark when the animation is a "fill" style animation.
////        checkBox.secondaryCheckmarkTintColor = .red
//
//        // Whether or not to display a checkmark, or radio mark.
//        checkBox.markType = .checkmark
////        // The line width of the checkmark.
//        checkBox.checkmarkLineWidth = 2.0
////
////        // The line width of the box.
//        checkBox.boxLineWidth = 2.0
////        // The corner radius of the box if it is a square.
//        checkBox.cornerRadius = 4.0
////        // Whether the box is a square, or circle.
//        checkBox.boxType = .circle
////        // Whether or not to hide the box.
        checkBox.stateChangeAnimation = .fill
//        checkBox.hideBox = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checklistButtonPressed(_ sender: UIButton) {
        delegate?.checklistButtonFlipped(index: index!)
        switchButtonState()
    }

    func setUpCell(){
        guard let checklistItem = checklistItemToDisplay else {return}
        checkListItemLabel.text = checklistItem.name
        let checklistItemStatus = checklistItem.checked
        let checkListItemChecked = checklistItemStatus 
        if checkListItemChecked {
            checkBox.checkState = .checked
        } else {
            checkBox.checkState = .unchecked
        }
    }

    @IBAction func checkBoxPressed(_ sender: M13Checkbox) {
        switchButtonState()
        print("adkfjadsf")
    }
    func switchButtonState(){

    }

    @IBAction func checkboxButtonPressed(_ sender: M13Checkbox) {
        delegate?.checklistButtonFlipped(index: index!)

    }

}
