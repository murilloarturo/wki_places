import CoreLocation
import XCTest
@testable import PlacesLauncher

final class ConfirmCustomLocationUseCaseTests: XCTestCase {
    private let useCase = DefaultConfirmCustomLocationUseCase()

    func testBuildsNamedLocationFromSelection() throws {
        let location = try useCase.execute(
            name: "Apple Park",
            coordinate: CLLocationCoordinate2D(latitude: 37.33489, longitude: -122.00899)
        )

        XCTAssertEqual(
            location,
            PlaceLocation(name: "Apple Park", latitude: 37.33489, longitude: -122.00899)
        )
    }

    func testUsesDroppedPinNameWhenSelectionHasNoName() throws {
        let location = try useCase.execute(
            name: nil,
            coordinate: CLLocationCoordinate2D(latitude: -27.11272, longitude: -109.34969)
        )

        XCTAssertEqual(location.name, "Dropped pin")
    }

    func testRejectsMissingSelection() {
        XCTAssertThrowsError(try useCase.execute(name: nil, coordinate: nil)) { error in
            XCTAssertEqual(error as? CustomLocationConfirmationError, .noSelection)
        }
    }
}
