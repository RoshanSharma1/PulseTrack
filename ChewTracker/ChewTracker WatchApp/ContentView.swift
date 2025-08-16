import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
        NavigationView {
            if sessionManager.isSessionActive {
                MealSessionView()
            } else {
                TabView {
                    StartSessionView()
                        .tabItem {
                            Label("Start", systemImage: "fork.knife")
                        }
                    
                    NavigationLink(destination: RestaurantDetectionView()) {
                        VStack(spacing: 15) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            
                            Text("Nearby")
                                .font(.headline)
                            
                            Text("Find restaurants")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    .tabItem {
                        Label("Nearby", systemImage: "mappin.and.ellipse")
                    }
                    
                    NavigationLink(destination: HistoryView()) {
                        VStack(spacing: 15) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            
                            Text("History")
                                .font(.headline)
                            
                            Text("View past meals")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    .tabItem {
                        Label("History", systemImage: "chart.bar.fill")
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        VStack(spacing: 15) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("Settings")
                                .font(.headline)
                            
                            Text("Customize app")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
            }
        }
        .onAppear {
            // Set up notification categories
            notificationManager.setupNotificationCategories()
            
            // Check for restaurant if location tracking is enabled
            if locationManager.locationTrackingEnabled {
                locationManager.checkForRestaurants()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionManager())
    }
}

