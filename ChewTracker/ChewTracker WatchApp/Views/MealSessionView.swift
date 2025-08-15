import SwiftUI

struct MealSessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var elapsedTime = 0
    @State private var timer: Timer?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Meal in Progress")
                    .font(.headline)
                
                Text(timeString(from: elapsedTime))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Chews")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(sessionManager.totalChews)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Chews/Min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(sessionManager.chewsPerMinute)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(chewsPerMinuteColor)
                    }
                }
                .padding(.vertical, 5)
                
                Spacer()
                
                Button(action: {
                    sessionManager.endSession()
                    timer?.invalidate()
                }) {
                    Text("End Meal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var chewsPerMinuteColor: Color {
        if sessionManager.chewsPerMinute > 30 {
            return .red
        } else if sessionManager.chewsPerMinute > 20 {
            return .yellow
        } else {
            return .green
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct MealSessionView_Previews: PreviewProvider {
    static var previews: some View {
        MealSessionView()
            .environmentObject(SessionManager())
    }
}

