import SwiftUI

struct MealDetailView: View {
    let meal: MealSession
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(meal.formattedDate)
                    .font(.headline)
                
                Divider()
                
                StatRow(title: "Total Chews", value: "\(meal.totalChews)")
                StatRow(title: "Duration", value: "\(meal.duration) min")
                StatRow(title: "Avg. Chews/Min", value: "\(meal.averageChewsPerMinute)")
                StatRow(title: "Max Chews/Min", value: "\(meal.maxChewsPerMinute)")
                
                if let notes = meal.notes, !notes.isEmpty {
                    Divider()
                    
                    Text("Notes")
                        .font(.headline)
                    
                    Text(notes)
                        .font(.body)
                }
            }
            .padding()
        }
        .navigationTitle("Meal Details")
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: MealSession.sampleMeal)
    }
}

