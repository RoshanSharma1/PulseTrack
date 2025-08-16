import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("mealReminderNotifications") var mealReminderNotifications: Bool = true
    @AppStorage("restaurantDetectionNotifications") var restaurantDetectionNotifications: Bool = true
    @AppStorage("dailySummaryNotifications") var dailySummaryNotifications: Bool = true
    @AppStorage("notificationQuietHoursEnabled") var quietHoursEnabled: Bool = true
    @AppStorage("notificationQuietHoursStart") var quietHoursStart: Int = 22 // 10 PM
    @AppStorage("notificationQuietHoursEnd") var quietHoursEnd: Int = 8 // 8 AM
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
        requestAuthorization()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
                
                if let error = error {
                    print("Notification authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Restaurant Detection Notifications
    
    func scheduleRestaurantDetectionNotification(restaurantName: String) {
        guard notificationsEnabled && restaurantDetectionNotifications else { return }
        
        // Check if we're in quiet hours
        if isInQuietHours() {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Restaurant Detected"
        content.body = "You appear to be at \(restaurantName). Would you like to track your meal?"
        content.sound = .default
        content.categoryIdentifier = "RESTAURANT_DETECTED"
        
        // Create a trigger (immediate)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(
            identifier: "restaurant-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling restaurant notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Meal Reminder Notifications
    
    func scheduleMealReminderNotification(mealType: String, time: Date) {
        guard notificationsEnabled && mealReminderNotifications else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "\(mealType) Time"
        content.body = "Remember to track your chewing behavior for mindful eating."
        content.sound = .default
        content.categoryIdentifier = "MEAL_REMINDER"
        
        // Create date components for the trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        // Create a trigger (daily at specified time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(
            identifier: "meal-reminder-\(mealType.lowercased())",
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling meal reminder: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Daily Summary Notifications
    
    func scheduleDailySummaryNotification(time: Date) {
        guard notificationsEnabled && dailySummaryNotifications else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Chewing Summary"
        content.body = "Check your daily eating habits summary and progress."
        content.sound = .default
        content.categoryIdentifier = "DAILY_SUMMARY"
        
        // Create date components for the trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        // Create a trigger (daily at specified time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(
            identifier: "daily-summary",
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling daily summary: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Notification Management
    
    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func removePendingNotifications(withIdentifiers identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Helper Methods
    
    private func isInQuietHours() -> Bool {
        guard quietHoursEnabled else { return false }
        
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        
        // Check if current hour is within quiet hours
        if quietHoursStart < quietHoursEnd {
            // Simple case: quiet hours within the same day
            return hour >= quietHoursStart && hour < quietHoursEnd
        } else {
            // Complex case: quiet hours span across midnight
            return hour >= quietHoursStart || hour < quietHoursEnd
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Allow showing notifications while app is in foreground
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification response
        let identifier = response.notification.request.identifier
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        
        switch categoryIdentifier {
        case "RESTAURANT_DETECTED":
            if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // User tapped the notification - open the app to start meal tracking
                // This will be handled by the app delegate or scene delegate
                print("User wants to start meal tracking from restaurant notification")
            }
            
        case "MEAL_REMINDER":
            if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // User tapped the meal reminder notification
                print("User tapped meal reminder notification")
            }
            
        case "DAILY_SUMMARY":
            if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // User tapped the daily summary notification
                print("User tapped daily summary notification")
            }
            
        default:
            break
        }
        
        completionHandler()
    }
    
    // MARK: - Setup Notification Categories
    
    func setupNotificationCategories() {
        // Restaurant detection category with actions
        let startTrackingAction = UNNotificationAction(
            identifier: "START_TRACKING",
            title: "Start Tracking",
            options: .foreground
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS",
            title: "Dismiss",
            options: .destructive
        )
        
        let restaurantCategory = UNNotificationCategory(
            identifier: "RESTAURANT_DETECTED",
            actions: [startTrackingAction, dismissAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Register the category
        notificationCenter.setNotificationCategories([restaurantCategory])
    }
}

