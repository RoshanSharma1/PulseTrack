import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var isAuthorized = false
    @Published var currentLocation: CLLocation?
    @Published var nearbyRestaurants: [Restaurant] = []
    @Published var isInRestaurant = false
    
    @AppStorage("locationTrackingEnabled") private var locationTrackingEnabled = true
    @AppStorage("automaticRestaurantDetection") private var automaticRestaurantDetection = true
    @AppStorage("restaurantSearchRadius") private var searchRadius = 500.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
        
        // Load sample restaurants for testing
        nearbyRestaurants = Restaurant.samples
    }
    
    func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            if locationTrackingEnabled {
                locationManager.startUpdatingLocation()
            }
        default:
            isAuthorized = false
        }
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func toggleLocationTracking(_ enabled: Bool) {
        locationTrackingEnabled = enabled
        if enabled && isAuthorized {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        if automaticRestaurantDetection {
            checkForRestaurants()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    // MARK: - Restaurant Detection
    
    func checkForRestaurants() {
        // In a real app, this would use a service like Google Places API
        // For now, we'll just use our sample data and simulate detection
        
        guard let currentLocation = currentLocation else { return }
        
        // Update distances for sample restaurants
        for i in 0..<nearbyRestaurants.count {
            let restaurantLocation = CLLocation(
                latitude: nearbyRestaurants[i].latitude,
                longitude: nearbyRestaurants[i].longitude
            )
            nearbyRestaurants[i].distance = currentLocation.distance(from: restaurantLocation)
        }
        
        // Filter restaurants within search radius
        let nearbyRestaurants = self.nearbyRestaurants.filter { restaurant in
            guard let distance = restaurant.distance else { return false }
            return distance <= searchRadius
        }
        
        // Sort by distance
        self.nearbyRestaurants = nearbyRestaurants.sorted { 
            ($0.distance ?? Double.infinity) < ($1.distance ?? Double.infinity)
        }
        
        // Update isInRestaurant flag
        isInRestaurant = !nearbyRestaurants.isEmpty
    }
    
    func setCurrentRestaurant(_ restaurant: Restaurant?) {
        // This would be used to set the current restaurant for a meal session
        // In a real app, this might update a database or other state
    }
}

