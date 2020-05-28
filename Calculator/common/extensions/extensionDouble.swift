//
//  extensionDouble.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import Foundation

extension Double {
    func strWithoutZeroesAtEnd() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        return (formatter.string(for: self) ?? "").replacingOccurrences(of: ",", with: ".")
    }
}
