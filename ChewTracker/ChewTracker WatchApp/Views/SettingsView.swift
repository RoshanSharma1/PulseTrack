import SwiftUI

struct SettingsView: View {
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    
    var body: some View {
        List {
            Section(header: Text("Chewing Settings")) {
                VStack(alignment: .leading) {
                    Text("Chewing Threshold")
                        .font(.headline)
                    
                    Text("Haptic feedback when exceeding this value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Picker("Threshold", selection: $chewingThreshold) {
                        ForEach([20, 25, 30, 35, 40], id: \.self) { value in
                            Text("\(value) chews/min").tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                Toggle("Haptic Feedback", isOn: $hapticFeedbackEnabled)
            }
            
            Section(header: Text("About")) {
                VStack(alignment: .leading) {
                    Text("ChewTracker")
                        .font(.headline)
                    
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("© 2025 PulseTrack")
                    .font(.caption)
                    .foregroundColor(.secondary)
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

