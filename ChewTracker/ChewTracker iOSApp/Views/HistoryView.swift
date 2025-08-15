import SwiftUI

struct HistoryView: View {
    // In a real app, this would be connected to the shared data model
    @State private var mealHistory: [MealSession] = [
        MealSession.sampleMeal,
        MealSession.sampleMeal,
        MealSession.sampleMeal,
        MealSession.sampleMeal,
        MealSession.sampleMeal
    ]
    
    @State private var selectedTimeFrame = 0
    private let timeFrames = ["Day", "Week", "Month", "All"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Time frame picker
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(0..<timeFrames.count, id: \.self) { index in
                        Text(timeFrames[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Meal history list
                List {
                    ForEach(mealHistory) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealHistoryRow(meal: meal)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Meal History")
        }
    }
}

struct MealHistoryRow: View {
    let meal: MealSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(meal.formattedDate)
                    .font(.headline)
                
                Text("\(meal.totalChews) chews • \(meal.duration) min")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text("\(meal.averageChewsPerMinute) CPM")
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text("Average")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

