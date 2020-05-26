//
//  CalculatorButton.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

protocol CalculatorButtonActionDelegate: class {
    func buttonPressed(btn: UIButton)
}

@IBDesignable
class CalculatorButton: UIButton {
    
    weak var actionDelegate: CalculatorButtonActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.masksToBounds = true
        self.setupAction()
    }
    
    private func setupAction() {
        self.removeAllTargets()
        self.addTarget(self, action: #selector(onPress),
                       for: .touchUpInside)
        self.addTarget(self, action: #selector(animate), for: [.touchDown])
    }
    
    @objc
    func animate() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.60),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
            },
                       completion: nil
        )
    }
    
    @objc
    func onPress() {
        actionDelegate?.buttonPressed(btn: self)
        print("button pressed")
    }
}
