import SwiftUI

struct StartSessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("ChewTracker")
                    .font(.headline)
                
                Text("Track your chewing habits for mindful eating")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    sessionManager.startSession()
                }) {
                    Text("Start Meal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
                NavigationLink(destination: HistoryView()) {
                    Text("View History")
                        .font(.subheadline)
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

struct StartSessionView_Previews: PreviewProvider {
    static var previews: some View {
        StartSessionView()
            .environmentObject(SessionManager())
    }
}

