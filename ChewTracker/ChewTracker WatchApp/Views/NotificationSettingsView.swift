import SwiftUI

struct NotificationSettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("mealReminderNotifications") private var mealReminderNotifications = true
    @AppStorage("restaurantDetectionNotifications") private var restaurantDetectionNotifications = true
    @AppStorage("dailySummaryNotifications") private var dailySummaryNotifications = true
    @AppStorage("notificationQuietHoursEnabled") private var quietHoursEnabled = true
    @AppStorage("notificationQuietHoursStart") private var quietHoursStart = 22 // 10 PM
    @AppStorage("notificationQuietHoursEnd") private var quietHoursEnd = 8 // 8 AM
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Notification Types")
                    .font(.headline)
                    .padding(.top)
                
                Toggle("Restaurant Detection", isOn: $restaurantDetectionNotifications)
                Toggle("Meal Reminders", isOn: $mealReminderNotifications)
                Toggle("Daily Summary", isOn: $dailySummaryNotifications)
                
                Divider()
                    .padding(.vertical)
                
                Text("Quiet Hours")
                    .font(.headline)
                
                Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)
                
                if quietHoursEnabled {
                    VStack(alignment: .leading) {
                        Text("Start Time")
                            .font(.subheadline)
                        
                        Picker("Start Time", selection: $quietHoursStart) {
                            ForEach(0..<24) { hour in
                                Text("\(formatHour(hour))").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        
                        Text("End Time")
                            .font(.subheadline)
                            .padding(.top)
                        
                        Picker("End Time", selection: $quietHoursEnd) {
                            ForEach(0..<24) { hour in
                                Text("\(formatHour(hour))").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding(.vertical)
                }
                
                Button("Request Notification Permission") {
                    notificationManager.requestAuthorization()
                }
                .buttonStyle(.bordered)
                .padding(.vertical)
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Notification Settings")
    }
    
    private func formatHour(_ hour: Int) -> String {
        let hourString = hour == 0 ? "12" : hour > 12 ? "\(hour - 12)" : "\(hour)"
        let amPm = hour >= 12 ? "PM" : "AM"
        return "\(hourString):00 \(amPm)"
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}

