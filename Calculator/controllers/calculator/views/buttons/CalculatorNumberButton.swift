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
    private var doItOnce = false

    @IBInspectable var numberText: String? {
        didSet {
            self.setTitle(numberText, for: .normal)
        }
    }

    var number: Int = 0 {
        didSet {
            numberText = "\(number)"
        }
    }
    
    required init (number: Int = 0) {
        self.number = number
        super.init(frame: CGRect.zero)
        self.initialSetup()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !doItOnce else { return }
        doItOnce = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.height / 2)
    }
    
    private func initialSetup() {
        self.backgroundColor = Theme.shared.colors.third
        self.setTitleColor(Theme.shared.colors.calculatorNumberColor, for: .normal)
        self.numberText = "\(number)"
        setNeedsLayout()
    }
}

@IBDesignable
class CalculatorTextButton: CalculatorButton {
    private var doItOnce = false

    @IBInspectable var text: String? {
        didSet {
            self.setTitle(text, for: .normal)
        }
    }
    
    required init (text: String = ",") {
        self.text = text
        super.init(frame: CGRect.zero)
        self.initialSetup()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !doItOnce else { return }
        doItOnce = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.height / 2)
    }
    
    private func initialSetup() {
        self.backgroundColor = Theme.shared.colors.third
        self.setTitleColor(Theme.shared.colors.calculatorNumberColor, for: .normal)
        self.text = ","
        setNeedsLayout()
    }
}
