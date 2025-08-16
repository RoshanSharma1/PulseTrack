import SwiftUI

struct SettingsView: View {
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    @AppStorage("selectedHapticPattern") private var selectedHapticPattern = HapticPattern.moderate.rawValue
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("selectedSound") private var selectedSound = SoundOption.gentleBeep.rawValue
    @AppStorage("soundVolume") private var soundVolume = 0.7
    @AppStorage("voiceFeedbackEnabled") private var voiceFeedbackEnabled = true
    @AppStorage("selectedVoiceStyle") private var selectedVoiceStyle = VoiceStyle.friendly.rawValue
    @AppStorage("voiceVolume") private var voiceVolume = 0.8
    @AppStorage("locationTrackingEnabled") private var locationTrackingEnabled = true
    @AppStorage("automaticRestaurantDetection") private var automaticRestaurantDetection = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    @State private var showingHapticSettings = false
    @State private var showingSoundSettings = false
    @State private var showingVoiceSettings = false
    @State private var showingLocationSettings = false
    @State private var showingNotificationSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Chewing Settings Section
                settingsSection(title: "Chewing Settings") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Chewing Threshold")
                            .font(.headline)
                        
                        Text("Alert when exceeding this value")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Picker("Threshold", selection: $chewingThreshold) {
                            ForEach([20, 25, 30, 35, 40], id: \\.self) { value in
                                Text("\\(value) chews/min").tag(value)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }
                
                // Feedback Settings Section
                settingsSection(title: "Feedback Options") {
                    VStack(alignment: .leading, spacing: 15) {
                        // Haptic Feedback
                        Toggle("Haptic Feedback", isOn: $hapticFeedbackEnabled)
                        
                        if hapticFeedbackEnabled {
                            Button(action: {
                                showingHapticSettings = true
                            }) {
                                HStack {
                                    Text("Vibration Pattern")
                                    Spacer()
                                    Text(selectedHapticPattern)
                                        .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingHapticSettings) {
                                HapticSettingsView()
                            }
                        }
                        
                        Divider()
                        
                        // Sound Feedback
                        Toggle("Sound Feedback", isOn: $soundEnabled)
                        
                        if soundEnabled {
                            Button(action: {
                                showingSoundSettings = true
                            }) {
                                HStack {
                                    Text("Sound Options")
                                    Spacer()
                                    Text(selectedSound)
                                        .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingSoundSettings) {
                                SoundSettingsView()
                            }
                            
                            // Sound Volume Slider
                            VStack(alignment: .leading) {
                                Text("Volume")
                                    .font(.subheadline)
                                
                                HStack {
                                    Image(systemName: "speaker.fill")
                                        .foregroundColor(.secondary)
                                    Slider(value: $soundVolume, in: 0...1)
                                    Image(systemName: "speaker.wave.3.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Voice Feedback
                        Toggle("Voice Feedback", isOn: $voiceFeedbackEnabled)
                        
                        if voiceFeedbackEnabled {
                            Button(action: {
                                showingVoiceSettings = true
                            }) {
                                HStack {
                                    Text("Voice Options")
                                    Spacer()
                                    Text(selectedVoiceStyle)
                                        .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingVoiceSettings) {
                                VoiceSettingsView()
                            }
                            
                            // Voice Volume Slider
                            VStack(alignment: .leading) {
                                Text("Voice Volume")
                                    .font(.subheadline)
                                
                                HStack {
                                    Image(systemName: "speaker.fill")
                                        .foregroundColor(.secondary)
                                    Slider(value: $voiceVolume, in: 0...1)
                                    Image(systemName: "speaker.wave.3.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                // Location Settings Section
                settingsSection(title: "Location Services") {
                    VStack(alignment: .leading, spacing: 15) {
                        Toggle("Location Tracking", isOn: $locationTrackingEnabled)
                        
                        if locationTrackingEnabled {
                            Toggle("Restaurant Detection", isOn: $automaticRestaurantDetection)
                            
                            Button(action: {
                                showingLocationSettings = true
                            }) {
                                HStack {
                                    Text("Location Settings")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingLocationSettings) {
                                LocationSettingsView()
                            }
                        }
                    }
                }
                
                // Notification Settings Section
                settingsSection(title: "Notifications") {
                    VStack(alignment: .leading, spacing: 15) {
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        
                        if notificationsEnabled {
                            Button(action: {
                                showingNotificationSettings = true
                            }) {
                                HStack {
                                    Text("Notification Settings")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingNotificationSettings) {
                                NotificationSettingsView()
                            }
                        }
                    }
                }
                
                // About Section
                settingsSection(title: "About") {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("ChewTracker")
                            .font(.headline)
                        
                        Text("Version 1.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("© 2025 PulseTrack")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Settings")
    }
    
    // Helper function to create consistent section styling
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content()
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .padding(.vertical, 5)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: - Subviews for Settings

struct HapticSettingsView: View {
    @AppStorage("selectedHapticPattern") private var selectedPattern: String = HapticPattern.moderate.rawValue
    @AppStorage("hapticIntensity") private var hapticIntensity: Double = 0.7
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var hapticManager = HapticManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Vibration Pattern")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(HapticPattern.allCases) { pattern in
                    Button(action: {
                        selectedPattern = pattern.rawValue
                        hapticManager.triggerWarningFeedback()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(pattern.rawValue)
                                    .font(.body)
                                
                                Text(pattern.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedPattern == pattern.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(selectedPattern == pattern.rawValue ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Intensity")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Subtle")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Strong")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $hapticIntensity, in: 0...1) { _ in
                        hapticManager.triggerWarningFeedback()
                    }
                }
                .padding(.bottom)
                
                Button("Test Vibration") {
                    hapticManager.triggerWarningFeedback()
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
        .navigationTitle("Haptic Settings")
    }
}

struct SoundSettingsView: View {
    @AppStorage("selectedSound") private var selectedSound: String = SoundOption.gentleBeep.rawValue
    @AppStorage("soundVolume") private var soundVolume: Double = 0.7
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Sound Options")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(SoundOption.allCases) { option in
                    Button(action: {
                        selectedSound = option.rawValue
                        soundManager.playWarningSound()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(option.rawValue)
                                    .font(.body)
                                
                                Text(option.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedSound == option.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(selectedSound == option.rawValue ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Volume")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $soundVolume, in: 0...1) { _ in
                            soundManager.playWarningSound()
                        }
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)
                
                Button("Test Sound") {
                    soundManager.playWarningSound()
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
        .navigationTitle("Sound Settings")
    }
}

struct VoiceSettingsView: View {
    @AppStorage("selectedVoiceStyle") private var selectedStyle: String = VoiceStyle.friendly.rawValue
    @AppStorage("voiceVolume") private var voiceVolume: Double = 0.8
    @AppStorage("voiceLanguageCode") private var languageCode: String = "en-US"
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var voiceFeedbackManager = VoiceFeedbackManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Voice Style")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(VoiceStyle.allCases) { style in
                    Button(action: {
                        selectedStyle = style.rawValue
                        voiceFeedbackManager.speakSlowDown()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(style.rawValue)
                                    .font(.body)
                                
                                Text(styleDescription(for: style))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedStyle == style.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(selectedStyle == style.rawValue ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Volume")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $voiceVolume, in: 0...1)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)
                
                Button("Test Voice") {
                    voiceFeedbackManager.speakSlowDown()
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
        .navigationTitle("Voice Settings")
    }
    
    private func styleDescription(for style: VoiceStyle) -> String {
        switch style {
        case .calm: return "Gentle, soothing voice"
        case .friendly: return "Warm, encouraging tone"
        case .coach: return "Motivational, energetic voice"
        case .professional: return "Clear, authoritative tone"
        }
    }
}

struct LocationSettingsView: View {
    @AppStorage("locationTrackingEnabled") private var locationTrackingEnabled = true
    @AppStorage("automaticRestaurantDetection") private var automaticRestaurantDetection = true
    @AppStorage("restaurantCheckFrequency") private var restaurantCheckFrequency: Double = 5 // minutes
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Location Services")
                    .font(.headline)
                    .padding(.top)
                
                Toggle("Enable Location Tracking", isOn: $locationTrackingEnabled)
                    .onChange(of: locationTrackingEnabled) { newValue in
                        locationManager.toggleLocationTracking(newValue)
                    }
                
                if locationTrackingEnabled {
                    Toggle("Automatic Restaurant Detection", isOn: $automaticRestaurantDetection)
                    
                    VStack(alignment: .leading) {
                        Text("Check Frequency")
                            .font(.subheadline)
                        
                        Text("How often to check for restaurants")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Picker("Frequency", selection: $restaurantCheckFrequency) {
                            Text("1 minute").tag(1.0)
                            Text("5 minutes").tag(5.0)
                            Text("10 minutes").tag(10.0)
                            Text("15 minutes").tag(15.0)
                            Text("30 minutes").tag(30.0)
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding(.vertical)
                    
                    Button("Request Location Permission") {
                        locationManager.requestLocationPermission()
                    }
                    .buttonStyle(.bordered)
                    .padding(.vertical)
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Privacy Information")
                    .font(.headline)
                
                Text("Your location data is only used to detect when you're at a restaurant. No location data is stored or shared with third parties.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Location Settings")
    }
}

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

