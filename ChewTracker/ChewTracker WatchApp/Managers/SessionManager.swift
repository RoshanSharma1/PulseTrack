import Foundation
import Combine
import SwiftUI

class SessionManager: ObservableObject {
    @Published var isSessionActive = false
    @Published var totalChews = 0
    @Published var chewsPerMinute = 0
    @Published var mealHistory: [MealSession] = []
    @Published var currentRestaurant: Restaurant?
    
    private var startTime: Date?
    private var chewsPerMinuteData: [Int] = []
    private var motionManager: MotionManager?
    private var hapticManager = HapticManager()
    private var soundManager = SoundManager()
    private var voiceFeedbackManager = VoiceFeedbackManager()
    private var timer: Timer?
    private var minuteTimer: Timer?
    private var currentMinuteChews = 0
    private var elapsedTimeInMinutes = 0
    
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("voiceFeedbackEnabled") private var voiceFeedbackEnabled = true
    
    init() {
        loadMealHistory()
    }
    
    func startSession(at restaurant: Restaurant? = nil) {
        isSessionActive = true
        startTime = Date()
        totalChews = 0
        chewsPerMinute = 0
        chewsPerMinuteData = []
        currentMinuteChews = 0
        elapsedTimeInMinutes = 0
        currentRestaurant = restaurant
        
        // Initialize and start motion detection
        motionManager = MotionManager()
        motionManager?.onChewDetected = { [weak self] in
            self?.chewDetected()
        }
        motionManager?.startMonitoring()
        
        // Start minute timer for CPM calculation
        startMinuteTimer()
        
        // Play start sound
        if soundEnabled {
            soundManager.playMealStartSound()
        }
    }
    
    func endSession() {
        guard let startTime = startTime else { return }
        
        isSessionActive = false
        motionManager?.stopMonitoring()
        timer?.invalidate()
        minuteTimer?.invalidate()
        
        // Record current minute's chews before ending
        if currentMinuteChews > 0 {
            chewsPerMinuteData.append(currentMinuteChews)
        }
        
        // Create and save meal session
        let meal = MealSession(
            id: UUID(),
            startTime: startTime,
            endTime: Date(),
            totalChews: totalChews,
            chewsPerMinuteData: chewsPerMinuteData,
            notes: nil,
            restaurantName: currentRestaurant?.name
        )
        
        // If we have a restaurant, update its visit count
        if var restaurant = currentRestaurant {
            restaurant.recordVisit()
            // In a real app, we would save this updated restaurant data
        }
        
        mealHistory.append(meal)
        saveMealHistory()
        
        // Play end sound
        if soundEnabled {
            soundManager.playMealEndSound()
        }
        
        // Reset state
        self.startTime = nil
        motionManager = nil
        currentRestaurant = nil
    }
    
    private func chewDetected() {
        DispatchQueue.main.async {
            self.totalChews += 1
            self.currentMinuteChews += 1
            self.chewsPerMinute = self.currentMinuteChews
            
            // Check if chewing too fast and provide feedback
            if self.chewsPerMinute > self.chewingThreshold {
                // Haptic feedback
                if self.hapticFeedbackEnabled {
                    self.hapticManager.triggerWarningFeedback()
                }
                
                // Sound feedback
                if self.soundEnabled {
                    self.soundManager.playWarningSound()
                }
                
                // Voice feedback (less frequent)
                if self.voiceFeedbackEnabled && self.chewsPerMinute > self.chewingThreshold + 5 {
                    self.voiceFeedbackManager.provideFeedbackForChewingRate(self.chewsPerMinute)
                }
            } else if self.chewsPerMinute <= 20 && self.totalChews % 50 == 0 {
                // Positive reinforcement for good chewing pace
                if self.hapticFeedbackEnabled {
                    self.hapticManager.triggerSuccessFeedback()
                }
                
                if self.soundEnabled {
                    self.soundManager.playSuccessSound()
                }
            }
        }
    }
    
    private func startMinuteTimer() {
        minuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Record the current minute's chews
            self.chewsPerMinuteData.append(self.currentMinuteChews)
            
            // Increment elapsed time
            self.elapsedTimeInMinutes += 1
            
            // Provide feedback based on meal duration
            if self.voiceFeedbackEnabled {
                self.voiceFeedbackManager.provideFeedbackForMealDuration(self.elapsedTimeInMinutes)
            }
            
            // Reset for the next minute
            self.currentMinuteChews = 0
            self.chewsPerMinute = 0
        }
    }
    
    // MARK: - Persistence
    
    private func saveMealHistory() {
        do {
            let data = try JSONEncoder().encode(mealHistory)
            UserDefaults.standard.set(data, forKey: "mealHistory")
        } catch {
            print("Failed to save meal history: \(error)")
        }
    }
    
    private func loadMealHistory() {
        guard let data = UserDefaults.standard.data(forKey: "mealHistory") else { return }
        
        do {
            mealHistory = try JSONDecoder().decode([MealSession].self, from: data)
        } catch {
            print("Failed to load meal history: \(error)")
        }
    }
}

