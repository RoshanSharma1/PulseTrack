import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        List {
            if sessionManager.mealHistory.isEmpty {
                Text("No meal history yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(sessionManager.mealHistory.sorted(by: { $0.startTime > $1.startTime })) { meal in
                    NavigationLink(destination: MealDetailView(meal: meal)) {
                        MealHistoryRow(meal: meal)
                    }
                }
            }
        }
        .navigationTitle("Meal History")
    }
}

struct MealHistoryRow: View {
    let meal: MealSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(meal.title)
                    .font(.headline)
                
                Spacer()
                
                Text(meal.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Duration")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(meal.formattedDuration)
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Chews")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("\(meal.totalChews)")
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Pace")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(meal.chewingQualityDescription)
                        .font(.caption)
                        .foregroundColor(paceColor(for: meal))
                }
            }
            
            if let restaurantName = meal.restaurantName {
                Text("📍 \(restaurantName)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 5)
    }
    
    private func paceColor(for meal: MealSession) -> Color {
        switch meal.chewingQualityDescription {
        case "Too Fast":
            return .red
        case "Somewhat Fast":
            return .orange
        case "Good Pace":
            return .green
        case "Excellent Pace":
            return .blue
        default:
            return .primary
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let sessionManager = SessionManager()
        sessionManager.mealHistory = MealSession.sampleMeals
        
        return HistoryView()
            .environmentObject(sessionManager)
    }
}

