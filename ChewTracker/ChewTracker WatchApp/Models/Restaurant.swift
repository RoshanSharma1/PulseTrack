import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var distance: Double? // Distance in meters from current location
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var formattedDistance: String {
        guard let distance = distance else { return "Unknown" }
        
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let kilometers = distance / 1000
            return String(format: "%.1f km", kilometers)
        }
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Sample restaurants for preview and testing
    static var samples: [Restaurant] = [
        Restaurant(
            name: "Green Leaf Cafe",
            address: "123 Main St",
            latitude: 37.7749,
            longitude: -122.4194,
            distance: 350
        ),
        Restaurant(
            name: "Healthy Bites",
            address: "456 Market St",
            latitude: 37.7751,
            longitude: -122.4196,
            distance: 520
        ),
        Restaurant(
            name: "Fresh & Tasty",
            address: "789 Mission St",
            latitude: 37.7752,
            longitude: -122.4198,
            distance: 780
        ),
        Restaurant(
            name: "Organic Delights",
            address: "101 Howard St",
            latitude: 37.7753,
            longitude: -122.4199,
            distance: 950
        )
    ]
}

