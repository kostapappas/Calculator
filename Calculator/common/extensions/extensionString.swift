//
//  extensionString.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 27/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import Foundation

extension String {
    func isSingleNumber() -> Bool {
        return ["0", "1", "2", "3", "4", "5",
                "6", "7", "8", "9"].contains(self)
    }
    
    func hasMoreThanOneZeroAtBeggining() -> Bool {
        guard self.count > 1 else { return false }
        return (Int(self) ?? -1 == 0)
    }
    
    func hasAllreadyOneComma() -> Bool {
        //todo improve localization
        return self.contains(",")
    }
}
