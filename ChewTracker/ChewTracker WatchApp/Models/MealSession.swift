import Foundation

struct MealSession: Identifiable, Codable {
    var id: UUID
    var title: String
    var startTime: Date
    var duration: TimeInterval
    var totalChews: Int
    var chewsPerMinuteData: [Int]
    var restaurantName: String?
    var restaurantAddress: String?
    var notes: String?
    
    // Computed properties
    var endTime: Date {
        return startTime.addingTimeInterval(duration)
    }
    
    var averageChewsPerMinute: Int {
        guard duration > 0 else { return 0 }
        let minutes = duration / 60
        return Int(Double(totalChews) / minutes)
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
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var chewingQualityDescription: String {
        if averageChewsPerMinute > 35 {
            return "Too Fast"
        } else if averageChewsPerMinute > 25 {
            return "Somewhat Fast"
        } else if averageChewsPerMinute > 15 {
            return "Good Pace"
        } else {
            return "Excellent Pace"
        }
    }
}

// MARK: - Sample Data

extension MealSession {
    static var sampleMeals: [MealSession] = [
        MealSession(
            id: UUID(),
            title: "Breakfast",
            startTime: Calendar.current.date(byAdding: .hour, value: -4, to: Date())!,
            duration: 15 * 60, // 15 minutes
            totalChews: 320,
            chewsPerMinuteData: [18, 22, 25, 20, 18, 17, 15, 14, 12, 10, 8, 6, 5, 4, 2],
            restaurantName: nil,
            restaurantAddress: nil,
            notes: "Oatmeal with berries and nuts"
        ),
        MealSession(
            id: UUID(),
            title: "Lunch",
            startTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            duration: 25 * 60, // 25 minutes
            totalChews: 580,
            chewsPerMinuteData: [20, 25, 28, 30, 32, 30, 28, 25, 22, 20, 18, 15, 12, 10, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1],
            restaurantName: "Healthy Bites Cafe",
            restaurantAddress: "123 Main St",
            notes: "Grilled chicken salad with avocado"
        ),
        MealSession(
            id: UUID(),
            title: "Dinner",
            startTime: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            duration: 35 * 60, // 35 minutes
            totalChews: 750,
            chewsPerMinuteData: [15, 18, 22, 25, 28, 30, 32, 30, 28, 25, 22, 20, 18, 15, 12, 10, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            restaurantName: "Farm to Table",
            restaurantAddress: "456 Oak Ave",
            notes: "Salmon with roasted vegetables"
        ),
        MealSession(
            id: UUID(),
            title: "Snack",
            startTime: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            duration: 8 * 60, // 8 minutes
            totalChews: 120,
            chewsPerMinuteData: [15, 18, 20, 18, 15, 12, 10, 8],
            restaurantName: nil,
            restaurantAddress: nil,
            notes: "Apple with almond butter"
        )
    ]
}

