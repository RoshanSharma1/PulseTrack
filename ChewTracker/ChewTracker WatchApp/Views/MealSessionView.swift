import SwiftUI

struct MealSessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var elapsedTime = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Meal in Progress")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Chews")
                        .font(.caption)
                    Text("\(sessionManager.totalChews)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("CPM")
                        .font(.caption)
                    Text("\(sessionManager.chewsPerMinute)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            
            Text(formattedTime)
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.semibold)
            
            Button(action: {
                sessionManager.endSession()
                timer?.invalidate()
                timer = nil
            }) {
                Text("End Meal")
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private var formattedTime: String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
}

struct MealSessionView_Previews: PreviewProvider {
    static var previews: some View {
        MealSessionView()
            .environmentObject(SessionManager())
    }
}

