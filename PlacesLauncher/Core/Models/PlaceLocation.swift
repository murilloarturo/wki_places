import CoreLocation
import Foundation

struct LocationFeedResponse: Decodable, Equatable, Sendable {
    let locations: [PlaceLocation]
}

struct PlaceLocation: Codable, Equatable, Hashable, Identifiable, Sendable {
    let name: String?
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }

    var id: String {
        "\(latitude),\(longitude)"
    }

    var displayName: String {
        guard let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            return "Unnamed location"
        }
        return name
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var formattedCoordinates: String {
        String(
            format: "%.5f, %.5f",
            locale: Locale(identifier: "en_US_POSIX"),
            latitude,
            longitude
        )
    }
}

enum CoordinateValidationError: LocalizedError, Equatable {
    case latitudeOutOfRange
    case longitudeOutOfRange
    case nonFiniteValue

    var errorDescription: String? {
        switch self {
        case .latitudeOutOfRange:
            return "Latitude must be between -90 and 90."
        case .longitudeOutOfRange:
            return "Longitude must be between -180 and 180."
        case .nonFiniteValue:
            return "The selected coordinate is not valid."
        }
    }
}

enum CoordinateValidator {
    static func validate(latitude: Double, longitude: Double) throws {
        guard latitude.isFinite, longitude.isFinite else {
            throw CoordinateValidationError.nonFiniteValue
        }
        guard (-90...90).contains(latitude) else {
            throw CoordinateValidationError.latitudeOutOfRange
        }
        guard (-180...180).contains(longitude) else {
            throw CoordinateValidationError.longitudeOutOfRange
        }
    }
}

