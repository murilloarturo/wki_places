import Foundation
import MapKit

protocol LocationSearching {
    func search(query: String) async throws -> PlaceSearchResult
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
