//
//  TabType.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import Foundation
import SwiftUI

enum TabType: Int, CaseIterable {
    case weather, stocks, settings, appInfo
    
    var title: String {
        switch self {
        case .weather:
            return NSLocalizedString("Weather", comment: "Tab title for weather")
        case .stocks:
            return NSLocalizedString("Stocks", comment: "Tab title for stocks")
        case .settings:
            return NSLocalizedString("Settings", comment: "Tab title for settings")
        case .appInfo:
            return NSLocalizedString("App Info", comment: "Tab title for app information")
        }
    }
    
    var image: String {
        switch self {
        case .weather: "weather"
        case .stocks: "stocks"
        case .settings: "settings"
        case .appInfo: "appInfo"
        }
    }
}
