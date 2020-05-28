//
//  extensionUIApplication.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

extension UIApplication {
    // Screen width.
    class var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class var isGreekLang: Bool {
        if let langStr = Locale.current.languageCode, langStr == "el" {
            return true
        }
        return false
    }
    
    class var selectedLangStr: String {
        if let langStr = Locale.current.languageCode {
            return langStr
        } else {
            return "en"
        }
    }
    
    class var getUserAgent: String {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
        let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
        let systemVersion = UIDevice.current.systemVersion
        let bundleID = Bundle.main.bundleIdentifier!
        let modelName = UIDevice.modelName
        let lang = UIApplication.selectedLangStr
        return "DequaredCalculatorSample/\(appVersion) (build \(buildVersion);"
            + " bundle \(bundleID)) iOS/\(systemVersion)"
            + " (\(modelName); lang \(lang))"
        
    }
}
