import Foundation
import WatchKit

class HapticManager {
    func triggerWarningFeedback() {
        // Provide haptic feedback when chewing too fast
        WKInterfaceDevice.current().play(.notification)
    }
    
    func triggerSuccessFeedback() {
        // Provide haptic feedback for positive reinforcement
        WKInterfaceDevice.current().play(.success)
    }
    
    func triggerLightTap() {
        // Light tap for subtle feedback
        WKInterfaceDevice.current().play(.click)
    }
}

