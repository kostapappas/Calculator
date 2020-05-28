//
//  RoundButton.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.layer.masksToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
    }
}
