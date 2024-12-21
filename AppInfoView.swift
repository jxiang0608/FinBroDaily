//
//  AppInfoView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import SwiftUI

struct AppInfoView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            Color.black.opacity(1.0 - brightnessManager.brightness)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Image("FinBroDaily Logo")
                        .resizable()
                        .frame(width: 100, height: 100) // Adjust the size as needed
                        .cornerRadius(20) // Optional rounded corners
                        .shadow(radius: 5)
                        .padding()
                
                if let displayName = Bundle.main.displayName {
                    Text("App Name: \(displayName)")
                } else {
                    Text("App Name: Unknown")
                }
                
                if let version = Bundle.main.version {
                    Text("Version: \(version)")
                } else {
                    Text("Version: Unknown")
                }
                
                if let build = Bundle.main.build {
                    Text("Build Number: \(build)")
                } else {
                    Text("Build Number: Unknown")
                }
                
                if let copyright = Bundle.main.copyright {
                    Text(copyright)
                        .multilineTextAlignment(.center)
                } else {
                    Text("© 2024 Joy Xiang")
                }
            }
        }
    }
}

#Preview {
    AppInfoView()
        .environmentObject(BrightnessManager())
}
