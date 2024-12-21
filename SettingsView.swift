//
//  SettingsView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager

    // Define settings with @AppStorage
    @AppStorage("darkMode") private var darkMode: Bool = false
    @AppStorage("languageMandarin") private var languageMandarin: Bool = false
    @AppStorage("notificationEnabled") private var notificationEnabled: Bool = false
    @AppStorage("textSize") private var textSizeValue: Double = 14.0
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("reminderHour") private var reminderHour: Int = 9 // Default to 9 AM
    @AppStorage("reminderMinute") private var reminderMinute: Int = 0 // Default to 9:00 AM
    
    @State private var reminderTime: Date = Date()
    @State private var showActionSheet = false
    @State private var showResetConfirmation = false
    
    var textSize: CGFloat {
        get { CGFloat(textSizeValue) }
        set { textSizeValue = Double(newValue) }
    }

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            Color.black.opacity(1.0 - brightnessManager.brightness)
                .ignoresSafeArea()
            
            Form {
                Section(header: Text("Color Mode")) {
                    Toggle("Enable Dark Mode", isOn: $darkMode)
                        .onChange(of: darkMode) { _ in
                            // Trigger UI update when dark mode setting changes
                            updateColorScheme()
                        }
                }
                
                Section(header: Text("Language")) {
                    Toggle("Switch to Mandarin", isOn: $languageMandarin)
                        .onChange(of: languageMandarin) { _ in
                            updateLanguage()
                        }
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationEnabled)
                        .onChange(of: notificationEnabled) { isEnabled in
                            if isEnabled {
                                NotificationManager.shared.requestNotificationPermissions { granted in
                                    if granted {
                                        scheduleReminder()
                                    } else {
                                        DispatchQueue.main.async {
                                            notificationEnabled = false // Revert toggle if permissions are denied
                                        }
                                    }
                                }
                            } else {
                                NotificationManager.shared.cancelAllNotifications()
                            }
                        }
                    
                    if notificationEnabled {
                        DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .onChange(of: reminderTime) { newTime in
                                // Save the new reminder time to AppStorage
                                let calendar = Calendar.current
                                reminderHour = calendar.component(.hour, from: newTime)
                                reminderMinute = calendar.component(.minute, from: newTime)
                                scheduleReminder()
                            }
                    }
                }
                
//                Section(header: Text("Text Size")) {
//                    Slider(value: $textSizeValue, in: 12...24, step: 1)
//                        .padding()
//                    
//                    Text("Text Size: \(Int(textSize)) pt")
//                        .font(.system(size: textSize))
//                }
                
//                Section(header: Text("Brightness")) {
//                    Slider(value: $brightness, in: 0...1, step: 0.01) // Brightness slider
//                        .onChange(of: brightness) { newValue in
//                            DispatchQueue.main.async {
//                                UIScreen.main.brightness = newValue // Update screen brightness
//                            }
//                        }
//                        .onAppear {
//                            brightness = UIScreen.main.brightness
//                        }
//                    Text("Brightness: \(Int(brightness * 100))%")
//                        .font(.system(size: textSize))
//                }
                
                Section(header: Text(NSLocalizedString("Brightness", comment: "Brightness slider title"))) {
                    Slider(value: $brightnessManager.brightness, in: 0.1...1.0, step: 0.01) // Simulated brightness slider
                    Text("Brightness: \(Int(brightnessManager.brightness * 100))%")
                        .font(.system(size: textSize))
                }
                
                Section {
                    Button("Reset Settings") {
                        showActionSheet = true // Show the action sheet
                    }
                    .foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle("Settings")
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Reset Settings"),
                message: Text("Are you sure you want to reset all settings to their defaults?"),
                buttons: [
                    .destructive(Text("Reset")) {
                        resetSettings()
                    },
                    .cancel()
                ]
            )
        }
        .onAppear {
            initializeSetting()
        }
    }
    
    private func initializeSetting() {
        if isFirstLaunch {
            darkMode = false
            languageMandarin = false
            notificationEnabled = false
            isFirstLaunch = false
        } else {
            let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            darkMode = (userInterfaceStyle == .dark)
            
            let currentLanguage = Locale.preferredLanguages.first ?? "en"
            languageMandarin = currentLanguage.contains("zh-Hans")
        }
        
        var components = DateComponents()
        components.hour = reminderHour
        components.minute = reminderMinute
        reminderTime = Calendar.current.date(from: components) ?? Date()
    }
    
    private func resetSettings() {
        darkMode = false
        languageMandarin = false
        notificationEnabled = false
        textSizeValue = 14.0
        reminderTime = Date()
        brightnessManager.brightness = 1.0
        print("Settings have been reset.")
    }
    
    private func scheduleReminder() {
        // Schedule a daily reminder with the stored reminder time
        NotificationManager.shared.scheduleDailyReminder(at: reminderHour, minute: reminderMinute)
    }
    
    private func updateColorScheme() {
        // Force a refresh of the app's appearance
        if darkMode {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
    
    private func updateLanguage() {
        if languageMandarin {
            setAppLanguage("zh-Hans")
        } else {
            setAppLanguage("en")
        }
    }
    
    private func setAppLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Restart the app to apply changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(BrightnessManager())
}
