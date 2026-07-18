import Foundation
import UIKit

enum WikipediaDeepLinkError: LocalizedError, Equatable {
    case invalidCoordinate
    case couldNotOpen

    var errorDescription: String? {
        switch self {
        case .invalidCoordinate:
            return "That coordinate cannot be opened."
        case .couldNotOpen:
            return "Wikipedia could not be opened. Make sure the assignment build is installed."
        }
    }
}

enum WikipediaURLBuilder {
    static func placesURL(for location: PlaceLocation) throws -> URL {
        do {
            try CoordinateValidator.validate(
                latitude: location.latitude,
                longitude: location.longitude
            )
        } catch {
            throw WikipediaDeepLinkError.invalidCoordinate
        }

        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: decimalString(location.latitude)),
            URLQueryItem(name: "lon", value: decimalString(location.longitude))
        ]

        guard let url = components.url else {
            throw WikipediaDeepLinkError.invalidCoordinate
        }
        return url
    }

    private static func decimalString(_ value: Double) -> String {
        String(format: "%.8f", locale: Locale(identifier: "en_US_POSIX"), value)
            .replacingOccurrences(of: #"\.?0+$"#, with: "", options: .regularExpression)
    }
}

@MainActor
protocol WikipediaOpening {
    func open(location: PlaceLocation) async throws
}

struct WikipediaLauncher: WikipediaOpening {
    func open(location: PlaceLocation) async throws {
        let url = try WikipediaURLBuilder.placesURL(for: location)
        let didOpen = await withCheckedContinuation { continuation in
            UIApplication.shared.open(url, options: [:]) { opened in
                continuation.resume(returning: opened)
            }
        }
        guard didOpen else {
            throw WikipediaDeepLinkError.couldNotOpen
        }
    }
}

