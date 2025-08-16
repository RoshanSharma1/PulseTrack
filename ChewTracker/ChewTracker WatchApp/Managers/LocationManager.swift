import Foundation
import CoreLocation
import SwiftUI
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var currentLocation: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var isInRestaurant: Bool = false
    @Published var nearbyRestaurants: [Restaurant] = []
    @Published var lastCheckedLocation: CLLocation?
    
    var isAuthorized: Bool {
        return locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways
    }
    
    @AppStorage("locationTrackingEnabled") var locationTrackingEnabled: Bool = true
    @AppStorage("automaticRestaurantDetection") var automaticRestaurantDetection: Bool = true
    @AppStorage("restaurantCheckFrequency") var restaurantCheckFrequency: Double = 5 // minutes
    
    private var cancellables = Set<AnyCancellable>()
    private var locationUpdateTimer: Timer?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        
        // Request authorization
        locationManager.requestWhenInUseAuthorization()
        
        // Start location updates if enabled
        if locationTrackingEnabled {
            startLocationUpdates()
        }
        
        // Add sample restaurants for testing
        #if DEBUG
        addSampleRestaurants()
        #endif
    }
    
    private func addSampleRestaurants() {
        nearbyRestaurants = [
            Restaurant(id: UUID(), name: "Healthy Bites Cafe", address: "123 Main St", distance: 150, latitude: 0, longitude: 0),
            Restaurant(id: UUID(), name: "Green Garden Restaurant", address: "456 Oak Ave", distance: 300, latitude: 0, longitude: 0),
            Restaurant(id: UUID(), name: "Fresh & Tasty", address: "789 Pine Blvd", distance: 450, latitude: 0, longitude: 0)
        ]
    }
    
    // MARK: - Location Management
    
    func startLocationUpdates() {
        guard locationTrackingEnabled else { return }
        
        locationManager.startUpdatingLocation()
        
        // Set up timer for periodic restaurant checks
        setupRestaurantCheckTimer()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    private func setupRestaurantCheckTimer() {
        // Convert minutes to seconds
        let timeInterval = restaurantCheckFrequency * 60
        
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.checkForRestaurants()
        }
    }
    
    // MARK: - Restaurant Detection
    
    func checkForRestaurants() {
        guard automaticRestaurantDetection, 
              locationTrackingEnabled,
              let location = currentLocation else { return }
        
        // Skip if we've checked this location recently (within 100 meters)
        if let lastChecked = lastCheckedLocation, 
           location.distance(from: lastChecked) < 100 {
            return
        }
        
        // Update last checked location
        lastCheckedLocation = location
        
        // Use reverse geocoding to check if current location is a restaurant
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            // Check if the location might be a restaurant
            self.checkIfLocationIsRestaurant(placemark: placemark)
        }
    }
    
    private func checkIfLocationIsRestaurant(placemark: CLPlacemark) {
        // Check for restaurant indicators in address
        let possibleRestaurantKeywords = ["restaurant", "café", "cafe", "diner", "eatery", "bistro", "grill", "bar", "pub"]
        
        // Check name and address components
        if let name = placemark.name,
           possibleRestaurantKeywords.contains(where: { name.lowercased().contains($0) }) {
            self.isInRestaurant = true
            return
        }
        
        // Check POI category
        if let areasOfInterest = placemark.areasOfInterest,
           areasOfInterest.contains(where: { 
               possibleRestaurantKeywords.contains(where: { keyword in
                   $0.lowercased().contains(keyword)
               })
           }) {
            self.isInRestaurant = true
            return
        }
        
        // If we have a GoogleMapsService, we could use it here for more accurate detection
        // For now, we'll just set isInRestaurant to false if no restaurant indicators were found
        self.isInRestaurant = false
    }
    
    // MARK: - Helper Methods
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func toggleLocationTracking(_ enabled: Bool) {
        locationTrackingEnabled = enabled
        
        if enabled {
            startLocationUpdates()
        } else {
            stopLocationUpdates()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Update current location
        currentLocation = location
        
        // Check for restaurants if automatic detection is enabled
        if automaticRestaurantDetection {
            checkForRestaurants()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if locationTrackingEnabled {
                startLocationUpdates()
            }
        } else {
            stopLocationUpdates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
