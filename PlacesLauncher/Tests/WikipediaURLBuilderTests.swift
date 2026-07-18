import Foundation
import XCTest
@testable import PlacesLauncher

final class WikipediaURLBuilderTests: XCTestCase {
    func testBuildsPlacesDeepLinkWithLatAndLon() throws {
        let location = PlaceLocation(name: "Madrid", latitude: 40.4380638, longitude: -3.7495758)

        let url = try WikipediaURLBuilder.placesURL(for: location)
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))

        XCTAssertEqual(components.scheme, "wikipedia")
        XCTAssertEqual(components.host, "places")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "lat" })?.value, "40.4380638")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "lon" })?.value, "-3.7495758")
    }

    func testFormatsZeroWithoutLosingValue() throws {
        let url = try WikipediaURLBuilder.placesURL(
            for: PlaceLocation(name: "Null Island", latitude: 0, longitude: 0)
        )
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))

        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "lat" })?.value, "0")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "lon" })?.value, "0")
    }

    func testRejectsInvalidCoordinate() {
        XCTAssertThrowsError(
            try WikipediaURLBuilder.placesURL(
                for: PlaceLocation(name: nil, latitude: 120, longitude: 0)
            )
        ) { error in
            XCTAssertEqual(error as? WikipediaDeepLinkError, .invalidCoordinate)
        }
    }
}

