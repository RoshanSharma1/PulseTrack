import Foundation
import CoreLocation
import Combine

class GoogleMapsService: ObservableObject {
    // API key would normally be stored securely or retrieved from a secure source
    // For development purposes, we'll use a placeholder
    private let apiKey = "YOUR_GOOGLE_MAPS_API_KEY"
    private let baseURL = "https://maps.googleapis.com/maps/api/place"
    
    @Published var isLoading: Bool = false
    @Published var lastError: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Restaurant Search
    
    func searchNearbyRestaurants(location: CLLocation, radius: Int = 500) -> AnyPublisher<[Restaurant], Error> {
        isLoading = true
        lastError = nil
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Construct the URL for the Places API Nearby Search request
        let urlString = "\(baseURL)/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=restaurant&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlacesResponse.self, decoder: JSONDecoder())
            .map { response in
                // Convert API response to Restaurant objects
                return response.results.compactMap { place in
                    guard let placeId = place.place_id,
                          let name = place.name,
                          let location = place.geometry?.location,
                          let lat = location.lat,
                          let lng = location.lng,
                          let vicinity = place.vicinity else {
                        return nil
                    }
                    
                    return Restaurant(
                        id: placeId,
                        name: name,
                        address: vicinity,
                        latitude: lat,
                        longitude: lng,
                        cuisineType: place.types?.first,
                        rating: place.rating,
                        priceLevel: place.price_level,
                        isOpen: place.opening_hours?.open_now
                    )
                }
            }
            .handleEvents(
                receiveOutput: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.lastError = error.localizedDescription
                    }
                },
                receiveCancel: { [weak self] in
                    self?.isLoading = false
                }
            )
            .eraseToAnyPublisher()
    }
    
    // MARK: - Restaurant Details
    
    func getRestaurantDetails(placeId: String) -> AnyPublisher<Restaurant, Error> {
        isLoading = true
        lastError = nil
        
        // Construct the URL for the Places API Details request
        let urlString = "\(baseURL)/details/json?place_id=\(placeId)&fields=name,formatted_address,geometry,rating,price_level,opening_hours,types&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlaceDetailsResponse.self, decoder: JSONDecoder())
            .map { response in
                guard let result = response.result,
                      let name = result.name,
                      let address = result.formatted_address,
                      let location = result.geometry?.location,
                      let lat = location.lat,
                      let lng = location.lng else {
                    throw URLError(.cannotParseResponse)
                }
                
                return Restaurant(
                    id: placeId,
                    name: name,
                    address: address,
                    latitude: lat,
                    longitude: lng,
                    cuisineType: result.types?.first,
                    rating: result.rating,
                    priceLevel: result.price_level,
                    isOpen: result.opening_hours?.open_now
                )
            }
            .handleEvents(
                receiveOutput: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.lastError = error.localizedDescription
                    }
                },
                receiveCancel: { [weak self] in
                    self?.isLoading = false
                }
            )
            .eraseToAnyPublisher()
    }
}

// MARK: - API Response Models

// Response for nearby search
struct PlacesResponse: Codable {
    let results: [Place]
    let status: String
}

// Response for place details
struct PlaceDetailsResponse: Codable {
    let result: Place?
    let status: String
}

// Place model from Google Places API
struct Place: Codable {
    let place_id: String?
    let name: String?
    let vicinity: String?
    let formatted_address: String?
    let geometry: Geometry?
    let rating: Double?
    let price_level: Int?
    let types: [String]?
    let opening_hours: OpeningHours?
}

struct Geometry: Codable {
    let location: Location?
}

struct Location: Codable {
    let lat: Double?
    let lng: Double?
}

struct OpeningHours: Codable {
    let open_now: Bool?
}

