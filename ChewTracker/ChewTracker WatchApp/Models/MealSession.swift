import Foundation

struct MealSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let totalChews: Int
    let chewsPerMinuteData: [Int] // Array of CPM for each minute
    let notes: String?
    let restaurantName: String?
    let mealType: MealType?
    
    enum MealType: String, Codable, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        case other = "Other"
    }
    
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
    
    var title: String {
        if let restaurantName = restaurantName {
            return "Meal at \(restaurantName)"
        } else if let mealType = mealType {
            return mealType.rawValue
        } else {
            // Determine meal type based on time of day
            let hour = Calendar.current.component(.hour, from: startTime)
            if hour >= 5 && hour < 11 {
                return "Breakfast"
            } else if hour >= 11 && hour < 15 {
                return "Lunch"
            } else if hour >= 17 && hour < 22 {
                return "Dinner"
            } else {
                return "Meal"
            }
        }
    }
    
    var chewingQualityDescription: String {
        let avg = averageChewsPerMinute
        if avg > 35 {
            return "Too Fast"
        } else if avg > 25 {
            return "Somewhat Fast"
        } else if avg > 15 {
            return "Good Pace"
        } else {
            return "Excellent Pace"
        }
    }
    
    // Initializer with optional parameters
    init(id: UUID, startTime: Date, endTime: Date, totalChews: Int, chewsPerMinuteData: [Int], notes: String? = nil, restaurantName: String? = nil, mealType: MealType? = nil) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.totalChews = totalChews
        self.chewsPerMinuteData = chewsPerMinuteData
        self.notes = notes
        self.restaurantName = restaurantName
        self.mealType = mealType
    }
    
    // Sample data for previews
    static var sampleMeal: MealSession {
        MealSession(
            id: UUID(),
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date(),
            totalChews: 245,
            chewsPerMinuteData: [28, 32, 25, 30, 22, 18],
            notes: "Salad and sandwich",
            restaurantName: "Healthy Bites Café",
            mealType: .lunch
        )
    }
    
    static var sampleMeals: [MealSession] {
        [
            MealSession(
                id: UUID(),
                startTime: Date().addingTimeInterval(-3600),
                endTime: Date(),
                totalChews: 245,
                chewsPerMinuteData: [28, 32, 25, 30, 22, 18],
                notes: "Salad and sandwich",
                restaurantName: "Healthy Bites Café",
                mealType: .lunch
            ),
            MealSession(
                id: UUID(),
                startTime: Date().addingTimeInterval(-86400),
                endTime: Date().addingTimeInterval(-86400 + 2700),
                totalChews: 320,
                chewsPerMinuteData: [22, 25, 28, 30, 25, 20, 18, 15, 12],
                notes: "Steak with vegetables",
                restaurantName: "Grill House",
                mealType: .dinner
            ),
            MealSession(
                id: UUID(),
                startTime: Date().addingTimeInterval(-172800),
                endTime: Date().addingTimeInterval(-172800 + 1800),
                totalChews: 180,
                chewsPerMinuteData: [35, 38, 32, 30, 25],
                notes: "Oatmeal with fruits",
                mealType: .breakfast
            )
        ]
    }
}

