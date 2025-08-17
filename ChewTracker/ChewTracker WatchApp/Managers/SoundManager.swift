import Foundation
import AVFoundation
import SwiftUI

enum SoundOption: String, CaseIterable, Identifiable {
    case none = "None"
    case gentleBeep = "Gentle Beep"
    case chime = "Chime"
    case bell = "Bell"
    case alert = "Alert"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .none: return "No sound feedback"
        case .gentleBeep: return "Soft, unobtrusive beep"
        case .chime: return "Pleasant chime sound"
        case .bell: return "Clear bell tone"
        case .alert: return "Attention-grabbing alert"
        }
    }
    
    var filename: String? {
        switch self {
        case .none: return nil
        case .gentleBeep: return "gentle_beep"
        case .chime: return "chime"
        case .bell: return "bell"
        case .alert: return "alert"
        }
    }
}

class SoundManager: NSObject, ObservableObject {
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("selectedSound") private var selectedSound: String = SoundOption.gentleBeep.rawValue
    @AppStorage("soundVolume") private var soundVolume: Double = 0.7
    
    private var audioPlayer: AVAudioPlayer?
    
    var currentSoundOption: SoundOption {
        return SoundOption(rawValue: selectedSound) ?? .gentleBeep
    }
    
    // Play a warning sound when chewing too fast
    func playWarningSound() {
        guard soundEnabled, currentSoundOption != .none else { return }
        playSound(named: currentSoundOption.filename)
    }
    
    // Play a success sound when completing a meal
    func playSuccessSound() {
        guard soundEnabled else { return }
        playSound(named: "success")
    }
    
    // Play a notification sound
    func playNotificationSound() {
        guard soundEnabled else { return }
        playSound(named: "notification")
    }
    
    // Generic method to play a sound
    private func playSound(named filename: String?) {
        guard let filename = filename else { return }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else {
            print("Sound file not found: \(filename)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = Float(soundVolume)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    // Stop any currently playing sound
    func stopSound() {
        audioPlayer?.stop()
    }
}

