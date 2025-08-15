import SwiftUI

struct SettingsView: View {
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    @AppStorage("healthKitSync") private var healthKitSync = false
    
    var body: some View {
        Form {
            Section(header: Text("Chewing Settings")) {
                Stepper(value: $chewingThreshold, in: 10...60, step: 5) {
                    HStack {
                        Text("Chew Threshold")
                        Spacer()
                        Text("\(chewingThreshold) CPM")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 5)
                
                Toggle("Haptic Feedback", isOn: $hapticFeedbackEnabled)
                    .padding(.vertical, 5)
            }
            
            Section(header: Text("Data")) {
                Toggle("Sync with HealthKit", isOn: $healthKitSync)
                    .padding(.vertical, 5)
                
                Button(action: {
                    // Implement export functionality
                }) {
                    Text("Export Data")
                }
                .padding(.vertical, 5)
            }
            
            Section {
                Button(action: {
                    // Implement reset functionality
                }) {
                    Text("Reset All Data")
                        .foregroundColor(.red)
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

