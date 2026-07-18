import CoreLocation
import Foundation

enum CustomLocationConfirmationError: LocalizedError, Equatable {
    case noSelection

    var errorDescription: String? {
        "Move the map or search for a place before confirming."
    }
}

@MainActor
final class CustomLocationViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var isSearching = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedCoordinate: CLLocationCoordinate2D?
    @Published private(set) var selectedName: String?
    @Published private(set) var cameraRevision = 0

    private let searcher: any LocationSearching

    init(
        searcher: any LocationSearching,
        initialCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(
            latitude: 52.36760,
            longitude: 4.90410
        )
    ) {
        self.searcher = searcher
        selectedCoordinate = initialCoordinate
    }

    func search() async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            errorMessage = LocationSearchError.emptyQuery.localizedDescription
            return
        }

        isSearching = true
        errorMessage = nil
        defer { isSearching = false }

        do {
            let result = try await searcher.search(query: trimmedQuery)
            try Task.checkCancellation()
            selectedCoordinate = result.coordinate
            selectedName = result.title
            cameraRevision += 1
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateMapCenter(_ coordinate: CLLocationCoordinate2D) {
        do {
            try CoordinateValidator.validate(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            selectedCoordinate = coordinate
            selectedName = nil
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func confirmedLocation() throws -> PlaceLocation {
        guard let selectedCoordinate else {
            throw CustomLocationConfirmationError.noSelection
        }
        try CoordinateValidator.validate(
            latitude: selectedCoordinate.latitude,
            longitude: selectedCoordinate.longitude
        )
        return PlaceLocation(
            name: selectedName ?? "Dropped pin",
            latitude: selectedCoordinate.latitude,
            longitude: selectedCoordinate.longitude
        )
    }

    func clearError() {
        errorMessage = nil
    }
}

