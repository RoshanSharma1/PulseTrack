import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var cuisineType: String?
    var rating: Double?
    var priceLevel: Int?
    var isOpen: Bool?
    var distanceInMeters: Double?
    var lastVisited: Date?
    var visitCount: Int
    
    // Computed property for location
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // Formatted distance string
    var formattedDistance: String {
        guard let distance = distanceInMeters else {
            return "Unknown distance"
        }
        
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let kilometers = distance / 1000
            return String(format: "%.1fkm", kilometers)
        }
    }
    
    // Price level as dollar signs
    var priceSymbols: String {
        guard let priceLevel = priceLevel else {
            return "Price unknown"
        }
        
        return String(repeating: "$", count: priceLevel)
    }
    
    // Initialize from Google Places API result
    init(id: String, name: String, address: String, latitude: Double, longitude: Double, cuisineType: String? = nil, rating: Double? = nil, priceLevel: Int? = nil, isOpen: Bool? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.cuisineType = cuisineType
        self.rating = rating
        self.priceLevel = priceLevel
        self.isOpen = isOpen
        self.distanceInMeters = nil
        self.lastVisited = nil
        self.visitCount = 0
    }
    
    // Update distance from a given location
    mutating func updateDistance(from location: CLLocation) {
        self.distanceInMeters = location.distance(from: self.location)
    }
    
    // Record a visit to this restaurant
    mutating func recordVisit() {
        self.lastVisited = Date()
        self.visitCount += 1
    }
    
    // Equatable implementation
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
}

