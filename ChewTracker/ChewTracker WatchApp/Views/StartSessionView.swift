import SwiftUI

struct StartSessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fork.knife")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text("Ready to track your meal?")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button(action: {
                sessionManager.startSession()
            }) {
                Text("Start Meal")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
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

struct StartSessionView_Previews: PreviewProvider {
    static var previews: some View {
        StartSessionView()
            .environmentObject(SessionManager())
    }
}

