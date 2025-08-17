import SwiftUI

struct NotificationSettingsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("mealReminderEnabled") private var mealReminderEnabled = false
    @AppStorage("mealReminderTime") private var mealReminderTime = 12 // Hour of day
    @AppStorage("chewingRateAlerts") private var chewingRateAlerts = true
    @AppStorage("restaurantDetectionAlerts") private var restaurantDetectionAlerts = true
    @AppStorage("weeklyReportEnabled") private var weeklyReportEnabled = true
    @AppStorage("weeklyReportDay") private var weeklyReportDay = 1 // Monday
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        List {
            Section(header: Text("Notification Access")) {
                HStack {
                    Image(systemName: notificationManager.isAuthorized ? "bell.fill" : "bell.slash.fill")
                        .foregroundColor(notificationManager.isAuthorized ? .green : .red)
                    
                    VStack(alignment: .leading) {
                        Text(notificationManager.isAuthorized ? "Notifications Enabled" : "Notifications Disabled")
                            .font(.headline)
                        
                        Text(notificationManager.isAuthorized ? 
                             "ChewTracker can send you alerts" : 
                             "Enable notifications in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if !notificationManager.isAuthorized {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            WKExtension.shared().openSystemURL(url)
                        }
                    }
                }
            }
            
            Section(header: Text("Meal Reminders")) {
                Toggle("Daily Meal Reminder", isOn: $mealReminderEnabled)
                    .disabled(!notificationManager.isAuthorized)
                
                if mealReminderEnabled && notificationManager.isAuthorized {
                    Picker("Reminder Time", selection: $mealReminderTime) {
                        ForEach(6..<24) { hour in
                            Text("\(formatHour(hour))").tag(hour)
                        }
                    }
                }
            }
            
            Section(header: Text("Session Alerts")) {
                Toggle("Chewing Rate Alerts", isOn: $chewingRateAlerts)
                    .disabled(!notificationManager.isAuthorized)
                
                Toggle("Restaurant Detection", isOn: $restaurantDetectionAlerts)
                    .disabled(!notificationManager.isAuthorized)
            }
            
            Section(header: Text("Weekly Report")) {
                Toggle("Weekly Summary", isOn: $weeklyReportEnabled)
                    .disabled(!notificationManager.isAuthorized)
                
                if weeklyReportEnabled && notificationManager.isAuthorized {
                    Picker("Report Day", selection: $weeklyReportDay) {
                        ForEach(0..<7) { day in
                            Text(daysOfWeek[day]).tag(day)
                        }
                    }
                }
            }
        }
        .navigationTitle("Notifications")
    }
    
    private func formatHour(_ hour: Int) -> String {
        let hourString = hour > 12 ? "\(hour - 12)" : "\(hour)"
        let amPm = hour >= 12 ? "PM" : "AM"
        return "\(hourString):00 \(amPm)"
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
            .environmentObject(NotificationManager())
    }
}

