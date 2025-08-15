import SwiftUI

struct SettingsView: View {
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    @AppStorage("healthKitSync") private var healthKitSync = false
    @AppStorage("dailyChewGoal") private var dailyChewGoal = 1000
    
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Chewing Settings")) {
                    HStack {
                        Text("Chew Threshold")
                        Spacer()
                        Text("\(chewingThreshold) CPM")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: Binding(
                        get: { Double(chewingThreshold) },
                        set: { chewingThreshold = Int($0) }
                    ), in: 10...60, step: 5)
                    
                    Toggle("Haptic Feedback", isOn: $hapticFeedbackEnabled)
                }
                
                Section(header: Text("Goals")) {
                    HStack {
                        Text("Daily Chew Goal")
                        Spacer()
                        Text("\(dailyChewGoal)")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: Binding(
                        get: { Double(dailyChewGoal) },
                        set: { dailyChewGoal = Int($0) }
                    ), in: 500...2000, step: 100)
                }
                
                Section(header: Text("Health Integration")) {
                    Toggle("Sync with HealthKit", isOn: $healthKitSync)
                    
                    NavigationLink(destination: Text("Health Categories")) {
                        Text("Health Categories")
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button(action: {
                        // Export functionality would go here
                    }) {
                        Text("Export All Data")
                    }
                    
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("Reset All Data")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(destination: Text("Privacy Policy")) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: Text("Terms of Use")) {
                        Text("Terms of Use")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Reset All Data"),
                    message: Text("Are you sure you want to reset all data? This action cannot be undone."),
                    primaryButton: .destructive(Text("Reset")) {
                        // Reset functionality would go here
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

