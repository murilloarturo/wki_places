import CoreLocation
import Foundation

struct LocationFeedResponse: Codable, Equatable, Sendable {
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
            return L10n.Location.unnamed
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
            return L10n.Coordinate.Error.latitude
        case .longitudeOutOfRange:
            return L10n.Coordinate.Error.longitude
        case .nonFiniteValue:
            return L10n.Coordinate.Error.nonFinite
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
