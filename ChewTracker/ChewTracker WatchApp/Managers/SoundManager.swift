import Foundation
import AVFoundation
import SwiftUI

enum SoundOption: String, CaseIterable, Identifiable {
    case none = "None"
    case gentleBeep = "Gentle Beep"
    case chime = "Chime"
    case bell = "Bell"
    case whistle = "Whistle"
    case custom = "Custom"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .none: return "No sound feedback"
        case .gentleBeep: return "Subtle beep sound"
        case .chime: return "Pleasant chime sound"
        case .bell: return "Clear bell sound"
        case .whistle: return "Attention-grabbing whistle"
        case .custom: return "Your custom sound"
        }
    }
    
    var filename: String? {
        switch self {
        case .none: return nil
        case .gentleBeep: return "gentle_beep"
        case .chime: return "chime"
        case .bell: return "bell"
        case .whistle: return "whistle"
        case .custom: return "custom"
        }
    }
}

class SoundManager: ObservableObject {
    @AppStorage("selectedSound") private var selectedSoundOption: String = SoundOption.gentleBeep.rawValue
    @AppStorage("soundVolume") private var volume: Double = 0.7
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    // Get the currently selected sound option
    var currentSoundOption: SoundOption {
        return SoundOption(rawValue: selectedSoundOption) ?? .gentleBeep
    }
    
    init() {
        // Preload sound files
        preloadSounds()
    }
    
    private func preloadSounds() {
        for option in SoundOption.allCases {
            if let filename = option.filename {
                loadSound(named: filename)
            }
        }
    }
    
    private func loadSound(named filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "mp3") else {
            print("Sound file \(filename).mp3 not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[filename] = player
        } catch {
            print("Could not load sound file: \(error)")
        }
    }
    
    // MARK: - Sound playback
    
    func playSound(for event: SoundEvent) {
        guard soundEnabled else { return }
        
        // Don't play sounds if "None" is selected
        if currentSoundOption == .none {
            return
        }
        
        guard let filename = currentSoundOption.filename,
              let player = audioPlayers[filename] else {
            return
        }
        
        // Set volume based on user preference and event type
        let adjustedVolume = Float(volume)
        player.volume = adjustedVolume
        
        // Modify playback based on event type
        switch event {
        case .warning:
            // Play with slight urgency
            player.rate = 1.1
            player.play()
            
        case .success:
            player.rate = 1.0
            player.play()
            
        case .mealStart:
            player.rate = 1.0
            player.play()
            
        case .mealEnd:
            // Play twice for meal end
            player.rate = 1.0
            player.play()
            
            // Schedule another play after a short delay
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                player.play()
            }
            
        case .restaurantDetected:
            // Play with a bit more volume for notifications
            player.volume = min(1.0, adjustedVolume * 1.2)
            player.rate = 1.0
            player.play()
        }
    }
    
    // MARK: - Event types
    
    enum SoundEvent {
        case warning
        case success
        case mealStart
        case mealEnd
        case restaurantDetected
    }
    
    // Convenience methods
    
    func playWarningSound() {
        playSound(for: .warning)
    }
    
    func playSuccessSound() {
        playSound(for: .success)
    }
    
    func playMealStartSound() {
        playSound(for: .mealStart)
    }
    
    func playMealEndSound() {
        playSound(for: .mealEnd)
    }
    
    func playRestaurantDetectedSound() {
        playSound(for: .restaurantDetected)
    }
}

