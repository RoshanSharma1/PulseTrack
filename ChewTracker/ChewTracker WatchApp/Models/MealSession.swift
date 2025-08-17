import Foundation

struct MealSession: Identifiable, Codable {
    var id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date?
    var totalChews: Int
    var chewsPerMinuteData: [Int] // Array of chews per minute for each minute of the meal
    var restaurantName: String?
    var notes: String?
    
    // Computed properties
    var duration: Int {
        let end = endTime ?? Date()
        return Int(end.timeIntervalSince(startTime) / 60)
    }
    
    var formattedDuration: String {
        let minutes = duration
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
    
    var averageChewsPerMinute: Int {
        guard !chewsPerMinuteData.isEmpty else { return 0 }
        let sum = chewsPerMinuteData.reduce(0, +)
        return sum / chewsPerMinuteData.count
    }
    
    var maxChewsPerMinute: Int {
        return chewsPerMinuteData.max() ?? 0
    }
    
    var chewingQualityDescription: String {
        let avg = averageChewsPerMinute
        if avg > 35 {
            return "Too Fast"
        } else if avg > 25 {
            return "Somewhat Fast"
        } else if avg > 15 {
            return "Good Pace"
        } else if avg > 0 {
            return "Excellent Pace"
        } else {
            return "No Data"
        }
    }
    
    // Sample data for previews and testing
    static var sampleMeals: [MealSession] = [
        MealSession(
            title: "Lunch",
            startTime: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!,
            endTime: Calendar.current.date(byAdding: .hour, value: -2, to: Date()),
            totalChews: 245,
            chewsPerMinuteData: [28, 32, 25, 22, 18, 15],
            restaurantName: "Green Leaf Cafe",
            notes: "Felt rushed at the beginning but slowed down after the reminder."
        ),
        MealSession(
            title: "Breakfast",
            startTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            endTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!.addingTimeInterval(25 * 60),
            totalChews: 180,
            chewsPerMinuteData: [20, 18, 15, 12, 10],
            restaurantName: nil,
            notes: "Oatmeal with fruits. Good pace throughout."
        ),
        MealSession(
            title: "Dinner",
            startTime: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            endTime: Calendar.current.date(byAdding: .day, value: -2, to: Date())!.addingTimeInterval(45 * 60),
            totalChews: 320,
            chewsPerMinuteData: [35, 30, 25, 20, 18, 15, 12, 10],
            restaurantName: "Healthy Bites",
            notes: "Started too fast but improved after the haptic feedback."
        ),
        MealSession(
            title: "Lunch",
            startTime: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            endTime: Calendar.current.date(byAdding: .day, value: -3, to: Date())!.addingTimeInterval(30 * 60),
            totalChews: 210,
            chewsPerMinuteData: [22, 20, 18, 15, 12],
            restaurantName: nil,
            notes: nil
        ),
        MealSession(
            title: "Breakfast",
            startTime: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
            endTime: Calendar.current.date(byAdding: .day, value: -4, to: Date())!.addingTimeInterval(20 * 60),
            totalChews: 150,
            chewsPerMinuteData: [18, 15, 12, 10],
            restaurantName: nil,
            notes: "Quick breakfast but maintained good chewing pace."
        )
    ]
}

