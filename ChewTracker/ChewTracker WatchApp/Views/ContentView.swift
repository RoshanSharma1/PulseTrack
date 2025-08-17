import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionManager())
    }
}

