import SwiftUI

struct RestaurantDetectionView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isLoading = false
    @State private var showingStartConfirmation = false
    @State private var selectedRestaurant: Restaurant?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Detecting restaurants...")
                    .padding()
            } else if locationManager.nearbyRestaurants.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "location.slash.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No restaurants found nearby")
                        .font(.headline)
                    
                    Text("You can still start a meal without a location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        // Refresh restaurant detection
                        detectRestaurants()
                    }) {
                        Label("Retry Detection", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                    .padding(.top)
                }
                .padding()
            } else {
                List {
                    Section(header: Text("Nearby Restaurants")) {
                        ForEach(locationManager.nearbyRestaurants) { restaurant in
                            Button(action: {
                                selectedRestaurant = restaurant
                                showingStartConfirmation = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(restaurant.name)
                                            .font(.headline)
                                        
                                        Text(restaurant.address)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(restaurant.formattedDistance)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            // Start meal without restaurant
                            sessionManager.setCurrentRestaurant(nil)
                            sessionManager.startSession()
                        }) {
                            Text("Start without location")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .alert(isPresented: $showingStartConfirmation) {
                    Alert(
                        title: Text("Start Meal"),
                        message: Text("Start tracking your meal at \(selectedRestaurant?.name ?? "this restaurant")?"),
                        primaryButton: .default(Text("Start")) {
                            if let restaurant = selectedRestaurant {
                                sessionManager.setCurrentRestaurant(restaurant)
                                sessionManager.startSession(title: "Meal at \(restaurant.name)")
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle("Restaurant")
        .onAppear {
            detectRestaurants()
        }
    }
    
    private func detectRestaurants() {
        isLoading = true
        
        // Simulate restaurant detection (in a real app, this would use the LocationManager)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // This is just a placeholder - in a real app, the LocationManager would
            // actually populate the nearbyRestaurants array
            isLoading = false
        }
    }
}

struct RestaurantDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationManager()
        // Add sample data for preview
        
        return NavigationView {
            RestaurantDetectionView()
                .environmentObject(locationManager)
                .environmentObject(SessionManager())
        }
    }
}

