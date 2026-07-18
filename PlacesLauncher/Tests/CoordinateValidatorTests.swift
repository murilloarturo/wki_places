import XCTest
@testable import PlacesLauncher

final class CoordinateValidatorTests: XCTestCase {
    func testAcceptsBoundaryCoordinates() throws {
        XCTAssertNoThrow(try CoordinateValidator.validate(latitude: -90, longitude: 180))
        XCTAssertNoThrow(try CoordinateValidator.validate(latitude: 90, longitude: -180))
    }

    func testRejectsLatitudeOutsideWorld() {
        XCTAssertThrowsError(try CoordinateValidator.validate(latitude: 90.1, longitude: 0)) { error in
            XCTAssertEqual(error as? CoordinateValidationError, .latitudeOutOfRange)
        }
    }

    func testRejectsLongitudeOutsideWorld() {
        XCTAssertThrowsError(try CoordinateValidator.validate(latitude: 0, longitude: -180.1)) { error in
            XCTAssertEqual(error as? CoordinateValidationError, .longitudeOutOfRange)
        }
    }

    func testRejectsNonFiniteValues() {
        XCTAssertThrowsError(try CoordinateValidator.validate(latitude: .nan, longitude: 0)) { error in
            XCTAssertEqual(error as? CoordinateValidationError, .nonFiniteValue)
        }
    }
}

