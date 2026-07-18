import CoreLocation
import XCTest
@testable import PlacesLauncher

@MainActor
final class CustomLocationViewModelTests: XCTestCase {
    func testSearchUpdatesSelectionAndConfirmation() async throws {
        let expected = CLLocationCoordinate2D(latitude: 37.33489, longitude: -122.00899)
        let viewModel = CustomLocationViewModel(
            searcher: StubLocationSearcher(
                result: .success(
                    PlaceSearchResult(title: "Apple Park", subtitle: "Cupertino", coordinate: expected)
                )
            ),
            initialCoordinate: nil
        )
        viewModel.query = "Apple Park"

        await viewModel.search()
        let confirmed = try viewModel.confirmedLocation()

        XCTAssertEqual(viewModel.cameraRevision, 1)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(confirmed.name, "Apple Park")
        XCTAssertEqual(confirmed.latitude, expected.latitude, accuracy: 0.000001)
        XCTAssertEqual(confirmed.longitude, expected.longitude, accuracy: 0.000001)
    }

    func testSearchErrorIsPresentedWithoutDestroyingCurrentSelection() async {
        let initial = CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041)
        let viewModel = CustomLocationViewModel(
            searcher: StubLocationSearcher(result: .failure(LocationSearchError.noResults)),
            initialCoordinate: initial
        )
        viewModel.query = "Nowhere nearby"

        await viewModel.search()

        XCTAssertEqual(viewModel.errorMessage, LocationSearchError.noResults.localizedDescription)
        XCTAssertEqual(viewModel.selectedCoordinate?.latitude, initial.latitude)
        XCTAssertEqual(viewModel.selectedCoordinate?.longitude, initial.longitude)
    }

    func testEmptySearchProducesClearValidationError() async {
        let viewModel = CustomLocationViewModel(
            searcher: StubLocationSearcher(result: .failure(LocationSearchError.unavailable))
        )
        viewModel.query = "   "

        await viewModel.search()

        XCTAssertEqual(viewModel.errorMessage, LocationSearchError.emptyQuery.localizedDescription)
    }

    func testMapPanCreatesDroppedPinConfirmation() throws {
        let viewModel = CustomLocationViewModel(
            searcher: StubLocationSearcher(result: .failure(LocationSearchError.unavailable)),
            initialCoordinate: nil
        )
        viewModel.updateMapCenter(CLLocationCoordinate2D(latitude: -27.11272, longitude: -109.34969))

        let location = try viewModel.confirmedLocation()

        XCTAssertEqual(location.name, "Dropped pin")
        XCTAssertEqual(location.latitude, -27.11272, accuracy: 0.000001)
    }

    func testConfirmationWithoutSelectionFailsClearly() {
        let viewModel = CustomLocationViewModel(
            searcher: StubLocationSearcher(result: .failure(LocationSearchError.unavailable)),
            initialCoordinate: nil
        )

        XCTAssertThrowsError(try viewModel.confirmedLocation()) { error in
            XCTAssertEqual(error as? CustomLocationConfirmationError, .noSelection)
        }
    }
}

private struct StubLocationSearcher: LocationSearching {
    let result: Result<PlaceSearchResult, Error>

    func search(query: String) async throws -> PlaceSearchResult {
        try result.get()
    }
}

