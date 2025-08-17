import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject {
    @Published var isAuthorized = false
    
    override init() {
        super.init()
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if granted {
                    self.registerCategories()
                }
            }
        }
    }
    
    private func registerCategories() {
        // Register notification categories and actions
        let mealReminderCategory = UNNotificationCategory(
            identifier: "MEAL_REMINDER",
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        let chewingRateCategory = UNNotificationCategory(
            identifier: "CHEWING_RATE",
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([mealReminderCategory, chewingRateCategory])
    }
    
    // Schedule a daily meal reminder
    func scheduleMealReminder(hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Meal Reminder"
        content.body = "Remember to track your next meal with ChewTracker!"
        content.sound = .default
        content.categoryIdentifier = "MEAL_REMINDER"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "mealReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling meal reminder: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedule a weekly report notification
    func scheduleWeeklyReport(weekday: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Chewing Report"
        content.body = "Your weekly chewing habits summary is ready to view!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday + 1 // Convert from 0-based to 1-based (Sunday = 1)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weeklyReport", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling weekly report: \(error.localizedDescription)")
            }
        }
    }
    
    // Send a notification for fast chewing
    func sendChewingRateAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Slow Down"
        content.body = "You're chewing too quickly. Try to slow down for better digestion."
        content.sound = .default
        content.categoryIdentifier = "CHEWING_RATE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "chewingRate-\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending chewing rate alert: \(error.localizedDescription)")
            }
        }
    }
    
    // Send a notification for restaurant detection
    func sendRestaurantDetectionAlert(restaurantName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Restaurant Detected"
        content.body = "You appear to be at \(restaurantName). Would you like to track your meal?"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "restaurantDetection-\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending restaurant detection alert: \(error.localizedDescription)")
            }
        }
    }
    
    // Remove all pending notifications
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Remove specific notification
    func removePendingNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

