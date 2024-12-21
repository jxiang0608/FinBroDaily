//
//  Notifications.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/5/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // Request notification permissions
    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                completion(granted)
                if granted {
                    print("Notification permissions granted.")
                } else {
                    print("Notification permissions denied.")
                }
            }
        }
    }
    
    // Schedule a daily reminder at a specified time
    func scheduleDailyReminder(at hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        
        // Remove any existing notifications with the same identifier to avoid duplicates
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Don't forget to check FinBroDaily for updates on stocks!"
        content.sound = .default
        
        // Configure the time for the notification
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled at \(hour):\(minute).")
            }
        }
    }
    
    // Cancel all pending notifications
    func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("All notifications canceled.")
    }
}
