import SwiftUI

struct LocationSettingsView: View {
    @AppStorage("locationTrackingEnabled") private var locationTrackingEnabled = true
    @AppStorage("automaticRestaurantDetection") private var automaticRestaurantDetection = true
    @AppStorage("restaurantCheckFrequency") private var restaurantCheckFrequency: Double = 5 // minutes
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Location Services")
                    .font(.headline)
                    .padding(.top)
                
                Toggle("Enable Location Tracking", isOn: $locationTrackingEnabled)
                    .onChange(of: locationTrackingEnabled) { newValue in
                        locationManager.toggleLocationTracking(newValue)
                    }
                
                if locationTrackingEnabled {
                    Toggle("Automatic Restaurant Detection", isOn: $automaticRestaurantDetection)
                    
                    VStack(alignment: .leading) {
                        Text("Check Frequency")
                            .font(.subheadline)
                        
                        Text("How often to check for restaurants")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Picker("Frequency", selection: $restaurantCheckFrequency) {
                            Text("1 minute").tag(1.0)
                            Text("5 minutes").tag(5.0)
                            Text("10 minutes").tag(10.0)
                            Text("15 minutes").tag(15.0)
                            Text("30 minutes").tag(30.0)
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding(.vertical)
                    
                    Button("Request Location Permission") {
                        locationManager.requestLocationPermission()
                    }
                    .buttonStyle(.bordered)
                    .padding(.vertical)
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Privacy Information")
                    .font(.headline)
                
                Text("Your location data is only used to detect when you're at a restaurant. No location data is stored or shared with third parties.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Location Settings")
    }
}

struct LocationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSettingsView()
    }
}

