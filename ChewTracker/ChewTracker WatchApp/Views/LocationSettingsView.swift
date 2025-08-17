import SwiftUI
import CoreLocation

struct LocationSettingsView: View {
    @EnvironmentObject var locationManager: LocationManager
    @AppStorage("locationTrackingEnabled") private var locationTrackingEnabled = true
    @AppStorage("automaticRestaurantDetection") private var automaticRestaurantDetection = true
    @AppStorage("restaurantSearchRadius") private var searchRadius = 500.0
    @AppStorage("saveVisitedRestaurants") private var saveVisitedRestaurants = true
    
    var body: some View {
        List {
            Section(header: Text("Location Access")) {
                HStack {
                    Image(systemName: locationManager.isAuthorized ? "location.fill" : "location.slash.fill")
                        .foregroundColor(locationManager.isAuthorized ? .green : .red)
                    
                    VStack(alignment: .leading) {
                        Text(locationManager.isAuthorized ? "Location Access Granted" : "Location Access Denied")
                            .font(.headline)
                        
                        Text(locationManager.isAuthorized ? 
                             "ChewTracker can detect restaurants near you" : 
                             "Enable location access in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if !locationManager.isAuthorized {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            WKExtension.shared().openSystemURL(url)
                        }
                    }
                }
            }
            
            Section(header: Text("Restaurant Detection")) {
                Toggle("Enable Restaurant Detection", isOn: $automaticRestaurantDetection)
                    .disabled(!locationManager.isAuthorized)
                
                if automaticRestaurantDetection && locationManager.isAuthorized {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Search Radius: \(Int(searchRadius))m")
                            .font(.caption)
                        
                        Slider(value: $searchRadius, in: 100...1000, step: 100)
                    }
                    
                    Toggle("Save Visited Restaurants", isOn: $saveVisitedRestaurants)
                }
            }
            
            Section(header: Text("Privacy")) {
                Toggle("Location Tracking", isOn: $locationTrackingEnabled)
                    .onChange(of: locationTrackingEnabled) { _, newValue in
                        locationManager.toggleLocationTracking(newValue)
                    }
                
                Text("When disabled, no location data will be collected or stored")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Data Usage")) {
                Text("Restaurant data is provided by Google Maps and is only used to enhance your meal tracking experience")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Your location data never leaves your device")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Location Settings")
    }
}

struct LocationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSettingsView()
            .environmentObject(LocationManager())
    }
}

