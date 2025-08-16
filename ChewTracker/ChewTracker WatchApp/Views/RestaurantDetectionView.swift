import SwiftUI
import CoreLocation
import Combine

struct RestaurantDetectionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var locationManager = LocationManager()
    @StateObject private var googleMapsService = GoogleMapsService()
    
    @State private var nearbyRestaurants: [Restaurant] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Header
                Text("Nearby Restaurants")
                    .font(.headline)
                    .padding(.top)
                
                if isLoading {
                    ProgressView()
                        .padding()
                    
                    Text("Searching for restaurants...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                    
                    Button(action: {
                        fetchNearbyRestaurants()
                    }) {
                        Text("Retry")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else if nearbyRestaurants.isEmpty {
                    Text("No restaurants found nearby")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Button(action: {
                        fetchNearbyRestaurants()
                    }) {
                        Text("Refresh")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    // Restaurant List
                    ForEach(nearbyRestaurants) { restaurant in
                        RestaurantRow(restaurant: restaurant) {
                            // Start meal tracking for this restaurant
                            sessionManager.startSession()
                        }
                    }
                }
                
                // Manual Start Button
                Button(action: {
                    sessionManager.startSession()
                }) {
                    HStack {
                        Image(systemName: "fork.knife")
                            .font(.headline)
                        Text("Start Tracking Anyway")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding(.horizontal)
        }
        .onAppear {
            // Request location permissions if needed
            if locationManager.locationStatus == nil {
                locationManager.requestLocationPermission()
            }
            
            // Fetch nearby restaurants
            fetchNearbyRestaurants()
        }
    }
    
    private func fetchNearbyRestaurants() {
        guard let location = locationManager.currentLocation else {
            errorMessage = "Location not available"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        googleMapsService.searchNearbyRestaurants(location: location)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    isLoading = false
                    
                    if case .failure(let error) = completion {
                        errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { restaurants in
                    // Sort restaurants by distance
                    self.nearbyRestaurants = restaurants.map { restaurant in
                        var updatedRestaurant = restaurant
                        updatedRestaurant.updateDistance(from: location)
                        return updatedRestaurant
                    }.sorted { ($0.distanceInMeters ?? 0) < ($1.distanceInMeters ?? 0) }
                    
                    isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}

struct RestaurantRow: View {
    let restaurant: Restaurant
    let onStartTracking: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(restaurant.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if let cuisineType = restaurant.cuisineType {
                        Text(cuisineType.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 5) {
                        Text(restaurant.formattedDistance)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        if let rating = restaurant.rating {
                            HStack(spacing: 1) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", rating))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let priceLevel = restaurant.priceLevel {
                            Text(String(repeating: "$", count: priceLevel))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: onStartTracking) {
                    Image(systemName: "fork.knife")
                        .font(.headline)
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct RestaurantDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetectionView()
            .environmentObject(SessionManager())
    }
}

