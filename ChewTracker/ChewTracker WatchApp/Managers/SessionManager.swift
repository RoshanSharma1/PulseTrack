import Foundation
import SwiftUI
import Combine
import CoreMotion

class SessionManager: ObservableObject {
    // Published properties for UI updates
    @Published var isSessionActive: Bool = false
    @Published var sessionStartTime: Date?
    @Published var sessionDuration: TimeInterval = 0
    @Published var currentChewCount: Int = 0
    @Published var chewsPerMinute: Int = 0
    @Published var mealHistory: [MealSession] = []
    @Published var currentRestaurant: Restaurant? = nil
    @Published var chewsPerMinuteData: [Int] = []
    
    // Settings
    @AppStorage("targetChewsPerBite") private var targetChewsPerBite: Int = 30
    @AppStorage("warningThreshold") private var warningThreshold: Int = 35
    
    // Private properties
    private var timer: Timer?
    private var soundManager = SoundManager()
    private var voiceFeedbackManager = VoiceFeedbackManager()
    private var hapticManager = HapticManager()
    private var lastChewTime: Date?
    private var chewingRateCalculationTimer: Timer?
    private var minuteCounter: Int = 0
    
    init() {
        // Load saved meal history from UserDefaults
        loadMealHistory()
    }
    
    // MARK: - Session Management
    
    func startSession(title: String = "Meal", notes: String? = nil) {
        guard !isSessionActive else { return }
        
        isSessionActive = true
        sessionStartTime = Date()
        currentChewCount = 0
        chewsPerMinute = 0
        chewsPerMinuteData = []
        minuteCounter = 0
        
        // Start timer for updating session duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateSessionDuration()
        }
        
        // Start timer for calculating chews per minute
        chewingRateCalculationTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.calculateAndStoreChewingRate()
        }
        
        // Play start sound
        soundManager.playMealStartSound()
        
        // Provide initial voice feedback
        voiceFeedbackManager.speakEnjoyMeal()
    }
    
    func endSession() {
        guard isSessionActive, let startTime = sessionStartTime else { return }
        
        // Create a new meal session record
        let meal = MealSession(
            id: UUID(),
            title: "Meal",
            startTime: startTime,
            duration: sessionDuration,
            totalChews: currentChewCount,
            chewsPerMinuteData: chewsPerMinuteData,
            restaurantName: currentRestaurant?.name,
            restaurantAddress: currentRestaurant?.address,
            notes: nil
        )
        
        // Add to history and save
        mealHistory.append(meal)
        saveMealHistory()
        
        // Reset session state
        isSessionActive = false
        sessionStartTime = nil
        sessionDuration = 0
        currentChewCount = 0
        chewsPerMinute = 0
        currentRestaurant = nil
        
        // Invalidate timers
        timer?.invalidate()
        timer = nil
        chewingRateCalculationTimer?.invalidate()
        chewingRateCalculationTimer = nil
        
        // Play end sound
        soundManager.playMealEndSound()
    }
    
    func pauseSession() {
        // Implementation for pausing a session
    }
    
    func resumeSession() {
        // Implementation for resuming a session
    }
    
    // MARK: - Chew Tracking
    
    func recordChew() {
        guard isSessionActive else { return }
        
        currentChewCount += 1
        lastChewTime = Date()
        
        // Update chews per minute calculation
        updateChewsPerMinute()
        
        // Check if warning needed
        if chewsPerMinute > warningThreshold {
            // Provide feedback if chewing too fast
            hapticManager.triggerWarningFeedback()
            soundManager.playWarningSound()
            
            // Occasionally provide voice feedback
            if currentChewCount % 10 == 0 {
                voiceFeedbackManager.speakSlowDown()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateSessionDuration() {
        guard let startTime = sessionStartTime else { return }
        sessionDuration = Date().timeIntervalSince(startTime)
        
        // Provide periodic voice feedback based on duration
        let durationMinutes = Int(sessionDuration / 60)
        if durationMinutes % 5 == 0 && durationMinutes > 0 {
            voiceFeedbackManager.provideFeedbackForMealDuration(durationMinutes)
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
        if let encoded = try? JSONEncoder().encode(mealHistory) {
            UserDefaults.standard.set(encoded, forKey: "mealHistory")
        }
    }
    
    private func loadMealHistory() {
        if let savedMeals = UserDefaults.standard.data(forKey: "mealHistory"),
           let decodedMeals = try? JSONDecoder().decode([MealSession].self, from: savedMeals) {
            mealHistory = decodedMeals
        }
    }
    
    // MARK: - Restaurant Integration
    
    func setCurrentRestaurant(_ restaurant: Restaurant?) {
        currentRestaurant = restaurant
    }
}

