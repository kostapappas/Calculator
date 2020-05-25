//
//  CalculatorView.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit
import Stevia

enum CalculatorType {
    case simple
    case scientific
}

@IBDesignable
class CalculatorView: UIView {
    
    var type = CalculatorType.simple
    
    private let buttonComma = CalculatorTextButton(text: ",")
    private let button0 = CalculatorNumberButton(number: 0)
    private let button1 = CalculatorNumberButton(number: 1)
    private let button2 = CalculatorNumberButton(number: 2)
    private let button3 = CalculatorNumberButton(number: 3)
    private let button4 = CalculatorNumberButton(number: 4)
    private let button5 = CalculatorNumberButton(number: 5)
    private let button6 = CalculatorNumberButton(number: 6)
    private let button7 = CalculatorNumberButton(number: 7)
    private let button8 = CalculatorNumberButton(number: 8)
    private let button9 = CalculatorNumberButton(number: 9)
    private let buttonPlus = CalculatorActionButton(text: "+")
    private let buttonMinus = CalculatorActionButton(text: "-")
    private let buttonMultiply = CalculatorActionButton(text: "*")
    private let buttonDivide = CalculatorActionButton(text: "/")
    private let buttonCalculate = CalculatorActionButton(text: "=")
    
    required init (type: CalculatorType = .simple) {
        self.type = type
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
        let row1  = self.generateHorizontalStack(of: [button1,
                                                      button2,
                                                      button3,
                                                      buttonMinus])
        let row2  = self.generateHorizontalStack(of: [button4,
                                                      button5,
                                                      button6,
                                                      buttonMultiply])
        let row3  = self.generateHorizontalStack(of: [button7,
                                                      button8,
                                                      button9,
                                                      buttonDivide])
        let row0  = self.generateHorizontalStack(of: [button0,
                                                      buttonComma,
                                                      buttonPlus])
        
        let verticalStack   = UIStackView()
        verticalStack.axis  = NSLayoutConstraint.Axis.vertical
        verticalStack.distribution  = UIStackView.Distribution.fillEqually
        verticalStack.alignment = UIStackView.Alignment.fill
        verticalStack.spacing   = 8.0
        verticalStack.addArrangedSubview(row3)
        verticalStack.addArrangedSubview(row2)
        verticalStack.addArrangedSubview(row1)
        verticalStack.addArrangedSubview(row0)
        verticalStack.addArrangedSubview(buttonCalculate)

        self.subviews([verticalStack])
        verticalStack.fillContainer()

        self.backgroundColor = .white
    }
    
    private func generateHorizontalStack(of array: [UIView]) -> UIStackView {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalCentering
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing   = 8.0
        
        for (index, view) in array.enumerated() {
            stackView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            if array.count == 3 {
                view.aspectRation(1.0/(index == 0 ? 2.13 : 1.0)).isActive = true
            } else {
                view.aspectRation(1.0/1.0).isActive = true
            }
        }
        return stackView
    }
    
}

extension UIView {

    func aspectRation(_ ratio: CGFloat) -> NSLayoutConstraint {

        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}
