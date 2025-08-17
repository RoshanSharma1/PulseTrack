import SwiftUI

struct MealDetailView: View {
    let meal: MealSession
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Header
                VStack(alignment: .center, spacing: 5) {
                    Text(meal.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text(meal.formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let restaurantName = meal.restaurantName {
                        Text("📍 \(restaurantName)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                // Stats grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    statView(title: "Duration", value: meal.formattedDuration)
                    statView(title: "Total Chews", value: "\(meal.totalChews)")
                    statView(title: "Avg. Chews/Min", value: "\(meal.averageChewsPerMinute)")
                    statView(title: "Max Chews/Min", value: "\(meal.maxChewsPerMinute)")
                }
                .padding(.bottom)
                
                // Chewing quality
                VStack(alignment: .leading, spacing: 5) {
                    Text("Chewing Quality")
                        .font(.headline)
                    
                    HStack {
                        Text(meal.chewingQualityDescription)
                            .font(.body)
                            .foregroundColor(paceColor(for: meal))
                        
                        Spacer()
                        
                        qualityIndicator(for: meal)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                // Notes
                if let notes = meal.notes {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Notes")
                            .font(.headline)
                        
                        Text(notes)
                            .font(.body)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                
                // Chewing pattern chart (simplified for watchOS)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Chewing Pattern")
                        .font(.headline)
                    
                    if meal.chewsPerMinuteData.isEmpty {
                        Text("No data available")
                            .foregroundColor(.secondary)
                    } else {
                        // Simple bar chart representation
                        HStack(alignment: .bottom, spacing: 2) {
                            ForEach(0..<min(meal.chewsPerMinuteData.count, 10), id: \.self) { index in
                                let value = meal.chewsPerMinuteData[index]
                                let maxValue = meal.chewsPerMinuteData.max() ?? 1
                                let height = CGFloat(value) / CGFloat(maxValue) * 100
                                
                                VStack {
                                    Rectangle()
                                        .fill(barColor(for: value))
                                        .frame(height: max(5, height))
                                    
                                    if index % 2 == 0 {
                                        Text("\(index+1)")
                                            .font(.system(size: 8))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .frame(height: 120)
                        .padding(.top)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Meal Details")
    }
    
    private func statView(title: String, value: String) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
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
    
    private func barColor(for value: Int) -> Color {
        if value > 35 {
            return .red
        } else if value > 25 {
            return .orange
        } else if value > 15 {
            return .green
        } else {
            return .blue
        }
    }
    
    private func qualityIndicator(for meal: MealSession) -> some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(qualityColor(for: meal, index: i))
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    private func qualityColor(for meal: MealSession, index: Int) -> Color {
        let quality: Int
        
        switch meal.chewingQualityDescription {
        case "Too Fast":
            quality = 1
        case "Somewhat Fast":
            quality = 2
        case "Good Pace":
            quality = 4
        case "Excellent Pace":
            quality = 5
        default:
            quality = 3
        }
        
        return index < quality ? .green : .gray.opacity(0.3)
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: MealSession.sampleMeals[0])
    }
}

