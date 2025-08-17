import SwiftUI

struct ContentView: View {
    @StateObject private var sessionManager = SessionManager()
    @StateObject private var hapticManager = HapticManager()
    @StateObject private var soundManager = SoundManager()
    @StateObject private var voiceFeedbackManager = VoiceFeedbackManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationManager = NotificationManager()
    
    @State private var isSessionActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isSessionActive {
                    MealSessionView()
                } else {
                    StartSessionView()
                }
            }
            .navigationTitle("ChewTracker")
        }
        .onChange(of: sessionManager.isSessionActive) { _, newValue in
            isSessionActive = newValue
        }
        .environmentObject(sessionManager)
        .environmentObject(hapticManager)
        .environmentObject(soundManager)
        .environmentObject(voiceFeedbackManager)
        .environmentObject(locationManager)
        .environmentObject(notificationManager)
        .onAppear {
            // Set up dependencies
            sessionManager.setDependencies(
                hapticManager: hapticManager,
                soundManager: soundManager,
                voiceFeedbackManager: voiceFeedbackManager
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

