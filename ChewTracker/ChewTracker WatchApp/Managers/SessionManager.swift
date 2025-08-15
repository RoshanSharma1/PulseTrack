import Foundation
import Combine

class SessionManager: ObservableObject {
    @Published var isSessionActive = false
    @Published var totalChews = 0
    @Published var chewsPerMinute = 0
    @Published var mealHistory: [MealSession] = []
    
    private var startTime: Date?
    private var chewsPerMinuteData: [Int] = []
    private var motionManager: MotionManager?
    private var hapticManager = HapticManager()
    private var timer: Timer?
    private var minuteTimer: Timer?
    private var currentMinuteChews = 0
    
    @AppStorage("chewingThreshold") private var chewingThreshold = 30
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = true
    
    init() {
        loadMealHistory()
    }
    
    func startSession() {
        isSessionActive = true
        startTime = Date()
        totalChews = 0
        chewsPerMinute = 0
        chewsPerMinuteData = []
        currentMinuteChews = 0
        
        // Initialize and start motion detection
        motionManager = MotionManager()
        motionManager?.onChewDetected = { [weak self] in
            self?.chewDetected()
        }
        motionManager?.startMonitoring()
        
        // Start minute timer for CPM calculation
        startMinuteTimer()
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
            notes: nil
        )
        
        mealHistory.append(meal)
        saveMealHistory()
        
        // Reset state
        self.startTime = nil
        motionManager = nil
    }
    
    private func chewDetected() {
        DispatchQueue.main.async {
            self.totalChews += 1
            self.currentMinuteChews += 1
            self.chewsPerMinute = self.currentMinuteChews
            
            // Check if chewing too fast and provide haptic feedback
            if self.hapticFeedbackEnabled && self.chewsPerMinute > self.chewingThreshold {
                self.hapticManager.triggerWarningFeedback()
            }
        }
    }
    
    private func startMinuteTimer() {
        minuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Record the current minute's chews
            self.chewsPerMinuteData.append(self.currentMinuteChews)
            
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

