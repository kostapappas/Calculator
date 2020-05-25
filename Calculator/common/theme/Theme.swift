//
//  Theme.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

protocol ColorTheme {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var third: UIColor { get }
    var calculatorNumberColor: UIColor { get }
    var calculatorActionColor: UIColor { get }
    var calculatorScreenNumber: UIColor { get }
}

struct MainThemeColor: ColorTheme {
    var primary: UIColor  = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
    var secondary: UIColor  = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    var third: UIColor  = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    var calculatorNumberColor: UIColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var calculatorActionColor: UIColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var calculatorScreenNumber: UIColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct CustomTheme {
    let colors = MainThemeColor()
}

class Theme {
    static let shared = Theme()
    private init() {}
    
    var colors = MainThemeColor()
    
    func setTheme(customTheme: CustomTheme) {
        self.colors = customTheme.colors
    }
}
