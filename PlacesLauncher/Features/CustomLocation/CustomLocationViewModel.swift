import CoreLocation
import Foundation

@MainActor
final class CustomLocationViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var isSearching = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedCoordinate: CLLocationCoordinate2D?
    @Published private(set) var selectedName: String?
    @Published private(set) var cameraRevision = 0

    private let searchLocationUseCase: any SearchLocationUseCase
    private let confirmCustomLocationUseCase: any ConfirmCustomLocationUseCase

    init(
        searchLocationUseCase: any SearchLocationUseCase,
        confirmCustomLocationUseCase: any ConfirmCustomLocationUseCase,
        initialCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(
            latitude: 52.36760,
            longitude: 4.90410
        )
    ) {
        self.searchLocationUseCase = searchLocationUseCase
        self.confirmCustomLocationUseCase = confirmCustomLocationUseCase
        selectedCoordinate = initialCoordinate
    }

    func search() async {
        isSearching = true
        errorMessage = nil
        defer { isSearching = false }

        do {
            let result = try await searchLocationUseCase.execute(query: query)
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
        try confirmCustomLocationUseCase.execute(
            name: selectedName,
            coordinate: selectedCoordinate
        )
    }

    func clearError() {
        errorMessage = nil
    }
}
