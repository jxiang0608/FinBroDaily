//
//  FinBroDailyApp.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/5/24.
//

import SwiftUI

@main
struct FinBroDailyApp: App {
    let brightnessManager = BrightnessManager.shared // Singleton instance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(brightnessManager)
        }
    }
}
