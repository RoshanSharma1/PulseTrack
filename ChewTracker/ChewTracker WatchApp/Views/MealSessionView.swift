import SwiftUI

struct MealSessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var hapticManager: HapticManager
    @EnvironmentObject var soundManager: SoundManager
    @EnvironmentObject var voiceFeedbackManager: VoiceFeedbackManager
    
    @State private var elapsedTime = 0
    @State private var timer: Timer?
    @State private var showingEndConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Header with restaurant name if available
                if let restaurant = sessionManager.currentRestaurant {
                    Text("Meal at \(restaurant.name)")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Meal in Progress")
                        .font(.headline)
                }
                
                // Timer display
                Text(timeString(from: elapsedTime))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                
                Divider()
                
                // Chewing stats
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Chews")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(sessionManager.currentChewCount)")
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
                
                // Feedback status
                VStack(alignment: .leading, spacing: 8) {
                    Text("Feedback Status")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 15) {
                        feedbackIndicator(
                            icon: "speaker.wave.2.fill",
                            enabled: soundManager.currentSoundOption != .none,
                            label: "Sound"
                        )
                        
                        feedbackIndicator(
                            icon: "waveform.path.ecg",
                            enabled: true,
                            label: "Haptic"
                        )
                        
                        feedbackIndicator(
                            icon: "mic.fill",
                            enabled: true,
                            label: "Voice"
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Spacer()
                
                // Chewing pace feedback
                Text(chewingPaceFeedback)
                    .font(.headline)
                    .foregroundColor(chewsPerMinuteColor)
                    .padding(.vertical)
                
                // End meal button
                Button(action: {
                    showingEndConfirmation = true
                }) {
                    Text("End Meal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingEndConfirmation) {
                    Alert(
                        title: Text("End Meal?"),
                        message: Text("Are you sure you want to end this meal tracking session?"),
                        primaryButton: .destructive(Text("End")) {
                            sessionManager.endSession()
                            timer?.invalidate()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            // Stop any ongoing voice feedback
            voiceFeedbackManager.stopSpeaking()
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
    
    private var chewingPaceFeedback: String {
        let cpm = sessionManager.chewsPerMinute
        if cpm == 0 {
            return "Start chewing to track"
        } else if cpm > 35 {
            return "Slow down significantly!"
        } else if cpm > 30 {
            return "Chewing too fast"
        } else if cpm > 25 {
            return "Slightly fast pace"
        } else if cpm > 15 {
            return "Good chewing pace"
        } else {
            return "Excellent mindful eating"
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
    
    private func feedbackIndicator(icon: String, enabled: Bool, label: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(enabled ? .blue : .gray)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(enabled ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MealSessionView_Previews: PreviewProvider {
    static var previews: some View {
        MealSessionView()
            .environmentObject(SessionManager())
            .environmentObject(HapticManager())
            .environmentObject(SoundManager())
            .environmentObject(VoiceFeedbackManager())
    }
}

