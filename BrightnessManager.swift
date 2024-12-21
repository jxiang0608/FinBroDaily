//
//  BrightnessManager.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/5/24.
//

import Foundation
import SwiftUI

class BrightnessManager: ObservableObject {
    @Published var brightness: Double = 1.0 // Default to full brightness
    static let shared = BrightnessManager() // Singleton instance
}
