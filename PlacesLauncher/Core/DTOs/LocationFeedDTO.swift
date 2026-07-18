import Foundation

struct LocationFeedDTO: Codable, Equatable, Sendable {
    let locations: [LocationDTO]
}

struct LocationDTO: Codable, Equatable, Sendable {
    let name: String?
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
