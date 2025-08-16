import Foundation
import AVFoundation
import SwiftUI

enum VoicePhrase: String, CaseIterable, Identifiable {
    case slowDown = "Please slow down"
    case chewMore = "Chew more thoroughly"
    case goodPace = "Good pace, keep it up"
    case takeBreak = "Consider taking a break"
    case enjoyMeal = "Remember to enjoy your meal"
    
    var id: String { self.rawValue }
}

enum VoiceStyle: String, CaseIterable, Identifiable {
    case calm = "Calm"
    case friendly = "Friendly"
    case coach = "Coach"
    case professional = "Professional"
    
    var id: String { self.rawValue }
    
    // Voice parameters for different styles
    var parameters: (rate: Float, pitch: Float, volume: Float) {
        switch self {
        case .calm:
            return (rate: 0.45, pitch: 0.8, volume: 0.7)
        case .friendly:
            return (rate: 0.5, pitch: 1.0, volume: 0.8)
        case .coach:
            return (rate: 0.55, pitch: 1.1, volume: 0.9)
        case .professional:
            return (rate: 0.5, pitch: 0.9, volume: 0.8)
        }
    }
}

class VoiceFeedbackManager: NSObject, ObservableObject {
    @AppStorage("voiceFeedbackEnabled") private var voiceFeedbackEnabled: Bool = true
    @AppStorage("selectedVoiceStyle") private var selectedStyle: String = VoiceStyle.friendly.rawValue
    @AppStorage("voiceVolume") private var voiceVolume: Double = 0.8
    @AppStorage("voiceLanguageCode") private var languageCode: String = "en-US"
    
    private let synthesizer = AVSpeechSynthesizer()
    private var lastSpokenTime: Date = Date.distantPast
    private let minimumInterval: TimeInterval = 30 // Minimum seconds between voice feedback
    
    var currentVoiceStyle: VoiceStyle {
        return VoiceStyle(rawValue: selectedStyle) ?? .friendly
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - Voice Feedback Methods
    
    func speakPhrase(_ phrase: VoicePhrase) {
        guard voiceFeedbackEnabled else { return }
        
        // Check if enough time has passed since last spoken phrase
        let now = Date()
        if now.timeIntervalSince(lastSpokenTime) < minimumInterval {
            return
        }
        
        // Create utterance with the phrase
        let utterance = AVSpeechUtterance(string: phrase.rawValue)
        
        // Set voice based on language code
        if let voice = AVSpeechSynthesisVoice(language: languageCode) {
            utterance.voice = voice
        }
        
        // Apply style parameters
        let style = currentVoiceStyle.parameters
        utterance.rate = style.rate
        utterance.pitchMultiplier = style.pitch
        utterance.volume = style.volume * Float(voiceVolume)
        
        // Speak the phrase
        synthesizer.speak(utterance)
        
        // Update last spoken time
        lastSpokenTime = now
    }
    
    // Convenience methods for different feedback scenarios
    
    func speakSlowDown() {
        speakPhrase(.slowDown)
    }
    
    func speakChewMore() {
        speakPhrase(.chewMore)
    }
    
    func speakGoodPace() {
        speakPhrase(.goodPace)
    }
    
    func speakTakeBreak() {
        speakPhrase(.takeBreak)
    }
    
    func speakEnjoyMeal() {
        speakPhrase(.enjoyMeal)
    }
    
    // Method to provide feedback based on chewing rate
    func provideFeedbackForChewingRate(_ chewsPerMinute: Int) {
        guard voiceFeedbackEnabled else { return }
        
        if chewsPerMinute > 40 {
            speakSlowDown()
        } else if chewsPerMinute > 30 {
            speakChewMore()
        } else if chewsPerMinute > 0 && chewsPerMinute <= 20 {
            // Only occasionally provide positive feedback
            if Int.random(in: 1...10) == 1 { // 10% chance
                speakGoodPace()
            }
        }
    }
    
    // Method to provide feedback based on meal duration
    func provideFeedbackForMealDuration(_ durationMinutes: Int) {
        guard voiceFeedbackEnabled else { return }
        
        if durationMinutes > 20 {
            // Suggest taking a break if meal is getting long
            speakTakeBreak()
        } else if durationMinutes == 5 {
            // Reminder to enjoy the meal after a few minutes
            speakEnjoyMeal()
        }
    }
    
    // Stop any ongoing speech
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    // Get available voices for the settings
    func getAvailableLanguages() -> [String] {
        return AVSpeechSynthesisVoice.speechVoices().compactMap { $0.language }
    }
}

