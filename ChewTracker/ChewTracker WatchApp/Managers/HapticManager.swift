import Foundation
import WatchKit
import SwiftUI

enum HapticPattern: String, CaseIterable, Identifiable {
    case gentle = "Gentle"
    case moderate = "Moderate"
    case intense = "Intense"
    case escalating = "Escalating"
    case pulsing = "Pulsing"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .gentle: return "Subtle vibration for minimal distraction"
        case .moderate: return "Standard vibration for clear feedback"
        case .intense: return "Strong vibration for important alerts"
        case .escalating: return "Gradually increasing intensity"
        case .pulsing: return "Rhythmic pattern of vibrations"
        }
    }
}

class HapticManager: ObservableObject {
    @AppStorage("selectedHapticPattern") private var selectedPattern: String = HapticPattern.moderate.rawValue
    @AppStorage("hapticIntensity") private var hapticIntensity: Double = 0.7
    
    // Get the currently selected pattern
    var currentPattern: HapticPattern {
        return HapticPattern(rawValue: selectedPattern) ?? .moderate
    }
    
    // Trigger the appropriate haptic feedback based on the selected pattern
    func triggerFeedback(for event: HapticEvent) {
        switch currentPattern {
        case .gentle:
            triggerGentleFeedback(for: event)
        case .moderate:
            triggerModerateFeedback(for: event)
        case .intense:
            triggerIntenseFeedback(for: event)
        case .escalating:
            triggerEscalatingFeedback(for: event)
        case .pulsing:
            triggerPulsingFeedback(for: event)
        }
    }
    
    // MARK: - Event-based feedback
    
    enum HapticEvent {
        case warning
        case success
        case notification
        case chewDetected
    }
    
    func triggerWarningFeedback() {
        triggerFeedback(for: .warning)
    }
    
    func triggerSuccessFeedback() {
        triggerFeedback(for: .success)
    }
    
    func triggerNotificationFeedback() {
        triggerFeedback(for: .notification)
    }
    
    func triggerChewDetectedFeedback() {
        triggerFeedback(for: .chewDetected)
    }
    
    // MARK: - Pattern implementations
    
    private func triggerGentleFeedback(for event: HapticEvent) {
        switch event {
        case .warning:
            WKInterfaceDevice.current().play(.click)
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .notification:
            WKInterfaceDevice.current().play(.click)
        case .chewDetected:
            if hapticIntensity > 0.5 {
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
    
    private func triggerModerateFeedback(for event: HapticEvent) {
        switch event {
        case .warning:
            WKInterfaceDevice.current().play(.notification)
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .notification:
            WKInterfaceDevice.current().play(.notification)
        case .chewDetected:
            if hapticIntensity > 0.3 {
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
    
    private func triggerIntenseFeedback(for event: HapticEvent) {
        switch event {
        case .warning:
            // Play multiple haptics for more intensity
            DispatchQueue.global().async {
                WKInterfaceDevice.current().play(.notification)
                Thread.sleep(forTimeInterval: 0.1)
                WKInterfaceDevice.current().play(.notification)
            }
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .notification:
            DispatchQueue.global().async {
                WKInterfaceDevice.current().play(.notification)
                Thread.sleep(forTimeInterval: 0.2)
                WKInterfaceDevice.current().play(.click)
            }
        case .chewDetected:
            if hapticIntensity > 0.2 {
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
    
    private func triggerEscalatingFeedback(for event: HapticEvent) {
        switch event {
        case .warning:
            // Escalating pattern for warnings
            DispatchQueue.global().async {
                for _ in 1...3 {
                    WKInterfaceDevice.current().play(.click)
                    Thread.sleep(forTimeInterval: 0.15)
                }
                WKInterfaceDevice.current().play(.notification)
            }
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .notification:
            WKInterfaceDevice.current().play(.notification)
        case .chewDetected:
            // No feedback for individual chews in this pattern
            break
        }
    }
    
    private func triggerPulsingFeedback(for event: HapticEvent) {
        switch event {
        case .warning:
            // Pulsing pattern for warnings
            DispatchQueue.global().async {
                for _ in 1...Int(self.hapticIntensity * 5) {
                    WKInterfaceDevice.current().play(.click)
                    Thread.sleep(forTimeInterval: 0.2)
                }
            }
        case .success:
            DispatchQueue.global().async {
                WKInterfaceDevice.current().play(.click)
                Thread.sleep(forTimeInterval: 0.1)
                WKInterfaceDevice.current().play(.success)
            }
        case .notification:
            DispatchQueue.global().async {
                for _ in 1...2 {
                    WKInterfaceDevice.current().play(.click)
                    Thread.sleep(forTimeInterval: 0.2)
                }
            }
        case .chewDetected:
            // No feedback for individual chews in this pattern
            break
        }
    }
    
    // MARK: - Legacy methods for backward compatibility
    
    func triggerLightTap() {
        WKInterfaceDevice.current().play(.click)
    }
}

