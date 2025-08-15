import Foundation
import CoreMotion

class MotionManager {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private let updateInterval = 1.0 / 20.0 // 20 Hz
    
    // ML model would be integrated here in a real implementation
    private var mlManager: MLManager?
    
    // Callback for when a chew is detected
    var onChewDetected: (() -> Void)?
    
    // Thresholds for chew detection (would be tuned based on real data)
    private let accelerationThreshold = 0.1
    private let gyroThreshold = 0.2
    
    // State tracking
    private var lastAcceleration: CMAcceleration?
    private var isChewing = false
    private var lastChewTime = Date()
    private let minTimeBetweenChews = 0.5 // Minimum time between chews in seconds
    
    init() {
        queue.name = "com.chewtracker.motionQueue"
        mlManager = MLManager()
    }
    
    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (motion, error) in
            guard let self = self, let motion = motion else {
                if let error = error {
                    print("Error getting device motion: \(error)")
                }
                return
            }
            
            self.processMotionData(motion)
        }
    }
    
    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func processMotionData(_ motion: CMDeviceMotion) {
        // In a real implementation, this would use the ML model to detect chewing
        // For this prototype, we'll use a simple threshold-based approach
        
        let userAcceleration = motion.userAcceleration
        let rotationRate = motion.rotationRate
        
        // Simple chew detection based on jaw movement patterns
        // This is a placeholder - real implementation would use ML model
        let accelerationMagnitude = sqrt(
            pow(userAcceleration.x, 2) +
            pow(userAcceleration.y, 2) +
            pow(userAcceleration.z, 2)
        )
        
        let rotationMagnitude = sqrt(
            pow(rotationRate.x, 2) +
            pow(rotationRate.y, 2) +
            pow(rotationRate.z, 2)
        )
        
        // Check if the current motion could be a chew
        if accelerationMagnitude > accelerationThreshold && rotationMagnitude > gyroThreshold {
            // Check if enough time has passed since the last chew
            let now = Date()
            if now.timeIntervalSince(lastChewTime) >= minTimeBetweenChews {
                // Detected a chew
                lastChewTime = now
                
                // Notify listeners
                DispatchQueue.main.async {
                    self.onChewDetected?()
                }
            }
        }
        
        // Update last acceleration for next comparison
        lastAcceleration = userAcceleration
    }
}

