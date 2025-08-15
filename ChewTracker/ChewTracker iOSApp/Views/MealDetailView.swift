import SwiftUI

struct MealDetailView: View {
    let meal: MealSession
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Meal header
                VStack(alignment: .leading, spacing: 5) {
                    Text(meal.formattedDate)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let notes = meal.notes {
                        Text(notes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Meal stats
                HStack {
                    StatCardView(value: "\(meal.totalChews)", label: "Total Chews")
                    StatCardView(value: "\(meal.duration)", label: "Minutes")
                    StatCardView(value: "\(meal.averageChewsPerMinute)", label: "Avg CPM")
                }
                .padding(.horizontal)
                
                // Chewing pattern chart
                VStack(alignment: .leading, spacing: 10) {
                    Text("Chewing Pattern")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // This would be a line chart in a real app
                    // Using a placeholder for now
                    ChewingPatternChartView(chewsPerMinuteData: meal.chewsPerMinuteData)
                }
                
                // Additional stats
                VStack(alignment: .leading, spacing: 10) {
                    Text("Details")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        DetailRowView(label: "Start Time", value: formatTime(meal.startTime))
                        DetailRowView(label: "End Time", value: formatTime(meal.endTime))
                        DetailRowView(label: "Max Chews/Min", value: "\(meal.maxChewsPerMinute)")
                        DetailRowView(label: "Avg Chews/Min", value: "\(meal.averageChewsPerMinute)")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Export button
                Button(action: {
                    // Export functionality would go here
                }) {
                    Text("Export Meal Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCardView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ChewingPatternChartView: View {
    let chewsPerMinuteData: [Int]
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 5) {
                ForEach(0..<chewsPerMinuteData.count, id: \.self) { index in
                    let value = chewsPerMinuteData[index]
                    let maxValue = chewsPerMinuteData.max() ?? 1
                    let height = CGFloat(value) / CGFloat(maxValue)
                    
                    VStack {
                        Rectangle()
                            .fill(Color.green)
                            .frame(height: 150 * height)
                        
                        Text("\(index + 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            HStack {
                Text("Minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Chews per Minute")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct DetailRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealDetailView(meal: MealSession.sampleMeal)
        }
    }
}

