import Foundation
import SwiftUI
import CoreMotion

class SessionManager: ObservableObject {
    // Published properties
    @Published var isSessionActive = false
    @Published var currentChewCount = 0
    @Published var chewsPerMinute = 0
    @Published var mealHistory: [MealSession] = []
    @Published var currentRestaurant: Restaurant? = nil
    @Published var chewsPerMinuteData: [Int] = []
    
    // Private properties
    private var sessionStartTime: Date?
    private var sessionTitle: String = "Meal"
    private var sessionNotes: String?
    private var chewsPerMinuteData: [Int] = []
    private var lastChewTime: Date?
    private var minuteTimer: Timer?
    private var motionManager = CMMotionManager()
    private var chewDetectionThreshold = 0.8 // Acceleration threshold for chew detection
    
    // Dependencies
    private var hapticManager: HapticManager?
    private var soundManager: SoundManager?
    private var voiceFeedbackManager: VoiceFeedbackManager?
    
    // Settings
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    
    init() {
        // Load saved meal history
        loadMealHistory()
    }
    
    // Set dependencies
    func setDependencies(hapticManager: HapticManager, soundManager: SoundManager, voiceFeedbackManager: VoiceFeedbackManager) {
        self.hapticManager = hapticManager
        self.soundManager = soundManager
        self.voiceFeedbackManager = voiceFeedbackManager
    }
    
    // MARK: - Session Management
    
    func startSession(title: String? = nil) {
        guard !isSessionActive else { return }
        
        sessionStartTime = Date()
        sessionTitle = title ?? "Meal"
        currentChewCount = 0
        chewsPerMinute = 0
        chewsPerMinuteData = []
        
        startMotionUpdates()
        startMinuteTimer()
        
        isSessionActive = true
    }
    
    func endSession() {
        guard isSessionActive, let startTime = sessionStartTime else { return }
        
        let endTime = Date()
        
        // Create meal session record
        let meal = MealSession(
            title: sessionTitle,
            startTime: startTime,
            endTime: endTime,
            totalChews: currentChewCount,
            chewsPerMinuteData: chewsPerMinuteData,
            restaurantName: currentRestaurant?.name,
            notes: sessionNotes
        )
        
        // Add to history and save
        mealHistory.append(meal)
        saveMealHistory()
        
        // Clean up
        stopMotionUpdates()
        minuteTimer?.invalidate()
        minuteTimer = nil
        
        // Reset state
        isSessionActive = false
        currentRestaurant = nil
        sessionNotes = nil
        
        // Play success sound
        soundManager?.playSuccessSound()
    }
    
    func pauseSession() {
        stopMotionUpdates()
    }
    
    func resumeSession() {
        startMotionUpdates()
    }
    
    func setCurrentRestaurant(_ restaurant: Restaurant?) {
        currentRestaurant = restaurant
    }
    
    func updateSessionNotes(_ notes: String) {
        sessionNotes = notes
    }
    
    // MARK: - Chew Detection
    
    private func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else { return }
            
            // Simple chew detection algorithm
            // In a real app, this would be more sophisticated, possibly using ML
            let acceleration = sqrt(
                pow(data.acceleration.x, 2) +
                pow(data.acceleration.y, 2) +
                pow(data.acceleration.z, 2)
            )
            
            if acceleration > self.chewDetectionThreshold {
                self.handleChewDetected()
            }
        }
    }
    
    private func stopMotionUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    private func handleChewDetected() {
        // Debounce chew detection (don't count chews too close together)
        let now = Date()
        if let lastChewTime = lastChewTime, now.timeIntervalSince(lastChewTime) < 0.5 {
            return
        }
        
        currentChewCount += 1
        lastChewTime = now
        
        // Provide haptic feedback for chew detection
        hapticManager?.triggerChewDetectedFeedback()
        
        // Check if chewing too fast
        if chewsPerMinute > chewingThreshold {
            hapticManager?.triggerWarningFeedback()
            soundManager?.playWarningSound()
            voiceFeedbackManager?.provideFeedbackForChewingRate(chewsPerMinute)
        }
        
        // Check meal duration for voice feedback
        if let startTime = sessionStartTime {
            let durationMinutes = Int(Date().timeIntervalSince(startTime) / 60)
            if durationMinutes % 5 == 0 { // Every 5 minutes
                voiceFeedbackManager?.provideFeedbackForMealDuration(durationMinutes)
            }
        }
    }
    
    // MARK: - Timer Management
    
    private func startMinuteTimer() {
        // Reset the minute timer
        minuteTimer?.invalidate()
        
        // Start a new timer that fires every minute
        minuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Record chews for the last minute
            self.chewsPerMinuteData.append(self.chewsPerMinute)
            
            // Reset the chews per minute counter
            self.chewsPerMinute = 0

        }
        
        // Also start a timer to update chews per minute more frequently
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self, self.isSessionActive else { return }
            
            // Calculate chews per minute based on recent activity
            self.updateChewsPerMinute()
        }
    }
    
    private func updateChewsPerMinute() {
        // This is a simplified calculation
        // In a real app, this would use a rolling window of recent chews
        
        guard let startTime = sessionStartTime else { return }
        
        let elapsedMinutes = Date().timeIntervalSince(startTime) / 60
        if elapsedMinutes > 0 {
            chewsPerMinute = Int(Double(currentChewCount) / elapsedMinutes)
        }
    }
    
    private func updateChewsPerMinute() {
        // Simple calculation based on recent chews
        // In a real implementation, this would use a sliding window
        guard let startTime = sessionStartTime else { return }
        
        let elapsedMinutes = Date().timeIntervalSince(startTime) / 60
        if elapsedMinutes > 0 {
            chewsPerMinute = Int(Double(currentChewCount) / elapsedMinutes)
        }
    }
    
    private func calculateAndStoreChewingRate() {
        minuteCounter += 1
        chewsPerMinuteData.append(chewsPerMinute)
        
        // Provide feedback based on chewing rate
        voiceFeedbackManager.provideFeedbackForChewingRate(chewsPerMinute)
    }
    
    // MARK: - Persistence
    
    private func saveMealHistory() {
        do {
            let data = try JSONEncoder().encode(mealHistory)
            UserDefaults.standard.set(data, forKey: "mealHistory")
        } catch {
            print("Failed to save meal history: \(error.localizedDescription)")
        }
    }
    
    private func loadMealHistory() {
        guard let data = UserDefaults.standard.data(forKey: "mealHistory") else {
            // Use sample data if no saved history
            mealHistory = MealSession.sampleMeals
            return
        }
        
        do {
            mealHistory = try JSONDecoder().decode([MealSession].self, from: data)
        } catch {
            print("Failed to load meal history: \(error.localizedDescription)")
            mealHistory = MealSession.sampleMeals
        }
    }
    
    // MARK: - History Management
    
    func deleteMeal(at indexSet: IndexSet) {
        mealHistory.remove(atOffsets: indexSet)
        saveMealHistory()
    }
    
    func clearAllHistory() {
        mealHistory = []
        saveMealHistory()
    }
}

