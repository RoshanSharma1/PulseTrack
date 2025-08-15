import SwiftUI

struct DashboardView: View {
    // In a real app, this would be connected to the shared data model
    @State private var mealHistory: [MealSession] = [
        MealSession.sampleMeal,
        MealSession.sampleMeal,
        MealSession.sampleMeal
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Today's summary
                    SummaryCardView(title: "Today's Summary", 
                                   totalChews: 245, 
                                   avgCPM: 28, 
                                   mealCount: 1)
                    
                    // Weekly stats
                    WeeklyStatsView()
                    
                    // Recent meals
                    VStack(alignment: .leading) {
                        Text("Recent Meals")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(mealHistory.prefix(3)) { meal in
                            NavigationLink(destination: MealDetailView(meal: meal)) {
                                MealCardView(meal: meal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Goal progress
                    GoalProgressView()
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct SummaryCardView: View {
    let title: String
    let totalChews: Int
    let avgCPM: Int
    let mealCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            HStack {
                StatItemView(value: "\(totalChews)", label: "Total Chews")
                Divider()
                StatItemView(value: "\(avgCPM)", label: "Avg CPM")
                Divider()
                StatItemView(value: "\(mealCount)", label: "Meals")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct StatItemView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeeklyStatsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Trends")
                .font(.headline)
                .padding(.horizontal)
            
            // This would be a chart in a real app
            // Using a placeholder for now
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7, id: \.self) { day in
                    let height = CGFloat([0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.2][day])
                    
                    VStack {
                        Rectangle()
                            .fill(Color.green)
                            .frame(height: 150 * height)
                        
                        Text(["M", "T", "W", "T", "F", "S", "S"][day])
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct MealCardView: View {
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
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct GoalProgressView: View {
    @State private var progress = 0.7
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Goal Progress")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("30 chews per bite")
                    .font(.subheadline)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                
                HStack {
                    Text("70% Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("21/30 chews")
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

