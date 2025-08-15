import Foundation

struct MealSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let totalChews: Int
    let chewsPerMinuteData: [Int] // Array of CPM for each minute
    let notes: String?
    
    var duration: Int {
        let seconds = endTime.timeIntervalSince(startTime)
        return Int(seconds / 60)
    }
    
    var averageChewsPerMinute: Int {
        if chewsPerMinuteData.isEmpty {
            return 0
        }
        return chewsPerMinuteData.reduce(0, +) / chewsPerMinuteData.count
    }
    
    var maxChewsPerMinute: Int {
        return chewsPerMinuteData.max() ?? 0
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
    
    // Sample data for previews
    static var sampleMeal: MealSession {
        MealSession(
            id: UUID(),
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date(),
            totalChews: 245,
            chewsPerMinuteData: [28, 32, 25, 30, 22, 18],
            notes: "Lunch - Salad and sandwich"
        )
    }
}

