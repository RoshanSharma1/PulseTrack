import SwiftUI

struct StartSessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var showingRestaurantDetection = false
    @State private var isNearRestaurant = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // App logo
                Image(systemName: "fork.knife")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("ChewTracker")
                    .font(.headline)
                
                Text("Track your chewing habits for mindful eating")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                // Restaurant detection banner (if near restaurant)
                if isNearRestaurant {
                    restaurantBanner
                }
                
                // Start meal button
                Button(action: {
                    sessionManager.startSession()
                }) {
                    Text("Start Meal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
                // Find restaurants button
                Button(action: {
                    showingRestaurantDetection = true
                }) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Find Restaurants")
                    }
                    .font(.subheadline)
                }
                .sheet(isPresented: $showingRestaurantDetection) {
                    RestaurantDetectionView()
                }
                
                // Navigation links
                NavigationLink(destination: HistoryView()) {
                    Text("View History")
                        .font(.subheadline)
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .onAppear {
            // Check if we're near a restaurant
            if locationManager.locationTrackingEnabled && locationManager.automaticRestaurantDetection {
                locationManager.checkForRestaurants()
                isNearRestaurant = locationManager.isInRestaurant
            }
        }
        .onChange(of: locationManager.isInRestaurant) { newValue in
            isNearRestaurant = newValue
        }
    }
    
    private var restaurantBanner: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.blue)
                
                Text("Restaurant Detected")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            Text("You appear to be at a restaurant. Would you like to track your meal?")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            HStack {
                Button(action: {
                    sessionManager.startSession()
                }) {
                    Text("Start Tracking")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isNearRestaurant = false
                }) {
                    Text("Dismiss")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .transition(.opacity)
        .animation(.easeInOut, value: isNearRestaurant)
    }
}

struct StartSessionView_Previews: PreviewProvider {
    static var previews: some View {
        StartSessionView()
            .environmentObject(SessionManager())
            .environmentObject(LocationManager())
    }
}

