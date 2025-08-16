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
                            Text("20 chews/min").tag(20)
                            Text("25 chews/min").tag(25)
                            Text("30 chews/min").tag(30)
                            Text("35 chews/min").tag(35)
                            Text("40 chews/min").tag(40)
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
                                    Text("Haptic Pattern")
                                    Spacer()
                                    Text(selectedHapticPattern)
                                        .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingHapticSettings) {
                                hapticSettingsView()
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
                                soundSettingsView()
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
                                    Text("Voice Style")
                                    Spacer()
                                    Text(selectedVoiceStyle)
                                        .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .sheet(isPresented: $showingVoiceSettings) {
                                voiceSettingsView()
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
                                locationSettingsView()
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
                                notificationSettingsView()
                            }
                        }
                    }
                }
                
                // About Section
                settingsSection(title: "About") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ChewTracker")
                            .font(.headline)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("© 2025 ChewTracker Team")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Settings")
    }
    
    // MARK: - Helper Views
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            content()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    // MARK: - Settings Detail Views
    
    private func hapticSettingsView() -> some View {
        NavigationView {
            List {
                ForEach(HapticPattern.allCases) { pattern in
                    Button(action: {
                        selectedHapticPattern = pattern.rawValue
                        // Trigger a sample of the haptic pattern
                        // hapticManager.triggerPattern(pattern)
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
                            
                            if selectedHapticPattern == pattern.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Haptic Pattern")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showingHapticSettings = false
                    }
                }
            }
        }
    }
    
    private func soundSettingsView() -> some View {
        NavigationView {
            List {
                ForEach(SoundOption.allCases) { option in
                    Button(action: {
                        selectedSound = option.rawValue
                        // Play a sample of the sound
                        // soundManager.playWarningSound()
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
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Section(header: Text("Volume")) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $soundVolume, in: 0...1)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Sound Options")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showingSoundSettings = false
                    }
                }
            }
        }
    }
    
    private func voiceSettingsView() -> some View {
        NavigationView {
            List {
                ForEach(VoiceStyle.allCases) { style in
                    Button(action: {
                        selectedVoiceStyle = style.rawValue
                        // Play a sample of the voice
                        // voiceFeedbackManager.speakGoodPace()
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
                            
                            if selectedVoiceStyle == style.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Section(header: Text("Volume")) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $voiceVolume, in: 0...1)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Voice Style")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showingVoiceSettings = false
                    }
                }
            }
        }
    }
    
    private func locationSettingsView() -> some View {
        NavigationView {
            LocationSettingsView()
        }
    }
    
    private func notificationSettingsView() -> some View {
        NavigationView {
            NotificationSettingsView()
        }
    }
    
    // MARK: - Helper Methods
    
    private func styleDescription(for style: VoiceStyle) -> String {
        switch style {
        case .calm:
            return "Gentle, soothing voice"
        case .friendly:
            return "Warm, encouraging tone"
        case .coach:
            return "Motivational, energetic"
        case .professional:
            return "Clear, instructional"
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

