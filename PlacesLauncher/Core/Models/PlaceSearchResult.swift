import CoreLocation
import Foundation

struct PlaceSearchResult: Sendable {
    let title: String
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
}

enum LocationSearchError: LocalizedError, Equatable {
    case emptyQuery
    case noResults
    case unavailable

    var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return L10n.Search.Error.empty
        case .noResults:
            return L10n.Search.Error.noResults
        case .unavailable:
            return L10n.Search.Error.unavailable
        }
    }
}
