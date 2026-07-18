import CoreLocation
import Foundation
import MapKit

struct PlaceSearchResult: Sendable {
    let title: String
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
}

protocol LocationSearching {
    func search(query: String) async throws -> PlaceSearchResult
}

enum LocationSearchError: LocalizedError, Equatable {
    case emptyQuery
    case noResults
    case unavailable

    var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Enter a place to search for."
        case .noResults:
            return "No matching place was found. Try a more specific search."
        case .unavailable:
            return "Apple Maps search is unavailable right now."
        }
    }
}

struct MapKitLocationSearcher: LocationSearching {
    func search(query: String) async throws -> PlaceSearchResult {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            throw LocationSearchError.emptyQuery
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = trimmedQuery
        request.resultTypes = [.address, .pointOfInterest]

        do {
            let response = try await MKLocalSearch(request: request).start()
            try Task.checkCancellation()
            guard let item = response.mapItems.first else {
                throw LocationSearchError.noResults
            }

            return PlaceSearchResult(
                title: item.name ?? trimmedQuery,
                subtitle: item.placemark.title,
                coordinate: item.placemark.coordinate
            )
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as LocationSearchError {
            throw error
        } catch {
            throw LocationSearchError.unavailable
        }
    }
}

