//
//  Label Kerning Extension.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/10/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addCharacterSpacing(value: Double) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
