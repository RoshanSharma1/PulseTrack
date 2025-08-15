import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        List {
            if sessionManager.mealHistory.isEmpty {
                Text("No meal history yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(sessionManager.mealHistory) { meal in
                    NavigationLink(destination: MealDetailView(meal: meal)) {
                        MealHistoryRow(meal: meal)
                    }
                }
            }
        }
        .navigationTitle("History")
    }
}

struct MealHistoryRow: View {
    let meal: MealSession
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(meal.formattedDate)
                .font(.headline)
            
            HStack {
                Text("\(meal.totalChews) chews")
                Spacer()
                Text("\(meal.duration) min")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(SessionManager())
    }
}

