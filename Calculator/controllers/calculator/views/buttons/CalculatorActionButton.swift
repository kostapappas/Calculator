//
//  CalculatorActionButton.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorActionButton: CalculatorButton {

    @IBInspectable var numberText: String? {
        didSet {
            self.setTitle(numberText, for: .normal)
            setNeedsLayout()
        }
    }

    required init (text: String = "=") {
        self.numberText = text
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialSetup()
    }
    
    override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
        self.initialSetup()
    }
    
    private func initialSetup() {
        self.backgroundColor = Theme.shared.colors.primary
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.height/1.4)
        self.setTitle(numberText ?? "=", for: .normal)
    }
}
