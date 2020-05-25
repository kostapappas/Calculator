//
//  CalculatorNumberButton.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorNumberButton: CalculatorButton {

    @IBInspectable var numberText: String? {
        didSet {
            self.setTitle(numberText, for: .normal)
            setNeedsLayout()
        }
    }

    var number: Int = 0
    
    required init (number: Int = 0) {
        self.number = number
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
        self.backgroundColor = Theme.shared.colors.secondary
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.height/2)
        self.setTitle(numberText ?? "1", for: .normal)
    }
}

@IBDesignable
class CalculatorTextButton: CalculatorButton {

    @IBInspectable var customText: String? {
        didSet {
            self.setTitle(customText, for: .normal)
            setNeedsLayout()
        }
    }

    required init (text: String = "5") {
        self.customText = text
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
        self.backgroundColor = Theme.shared.colors.secondary
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.height/2)
        self.setTitle(customText ?? "1", for: .normal)
    }
}
