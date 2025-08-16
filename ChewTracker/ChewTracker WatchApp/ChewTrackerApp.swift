import SwiftUI

@main
struct ChewTrackerApp: App {
    @StateObject private var sessionManager = SessionManager()
    @StateObject private var hapticManager = HapticManager()
    @StateObject private var soundManager = SoundManager()
    @StateObject private var voiceFeedbackManager = VoiceFeedbackManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
                .environmentObject(hapticManager)
                .environmentObject(soundManager)
                .environmentObject(voiceFeedbackManager)
                .environmentObject(locationManager)
                .environmentObject(notificationManager)
                .onAppear {
                    // Request necessary permissions on app launch
                    locationManager.requestLocationPermission()
                    notificationManager.requestAuthorization()
                }
        }
    }
}

