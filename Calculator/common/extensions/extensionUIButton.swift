//
//  extensionUIButton.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 26/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

extension UIButton {
    func removeAllTargets() {
        self.removeTarget(nil, action: nil, for: .allEvents)
    }
}
