import XCTest
@testable import Wikipedia

final class PlacesDeepLinkTests: XCTestCase {
    func testParsesLatitudeAndLongitude() throws {
        let deepLink = try XCTUnwrap(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=37.3349&lon=-122.0090")!))

        XCTAssertEqual(deepLink.latitude, 37.3349)
        XCTAssertEqual(deepLink.longitude, -122.0090)
    }

    func testAcceptsLongAlias() throws {
        let deepLink = try XCTUnwrap(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=51.5007&long=-0.1246")!))

        XCTAssertEqual(deepLink.latitude, 51.5007)
        XCTAssertEqual(deepLink.longitude, -0.1246)
    }

    func testAcceptsCoordinateRangeBoundaries() {
        XCTAssertNotNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=90&lon=180")!))
        XCTAssertNotNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=-90&lon=-180")!))
    }

    func testRejectsMissingOrMalformedCoordinates() {
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=1")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lon=1")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=north&lon=1")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=1&lon=west")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=nan&lon=1")!))
    }

    func testRejectsOutOfRangeCoordinates() {
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=90.1&lon=0")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=-90.1&lon=0")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=0&lon=180.1")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=0&lon=-180.1")!))
    }

    func testRejectsAmbiguousCoordinateParameters() {
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=1&lat=2&lon=3")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=1&lon=2&long=2")!))
    }

    func testRejectsOtherRoutes() {
        XCTAssertNil(PlacesDeepLink(url: URL(string: "https://places?lat=1&lon=2")!))
        XCTAssertNil(PlacesDeepLink(url: URL(string: "wikipedia://search?lat=1&lon=2")!))
    }

    func testRoundTripsThroughUserActivity() throws {
        let deepLink = try XCTUnwrap(PlacesDeepLink(url: URL(string: "wikipedia://places?lat=25.0003&lon=55.3014")!))
        let activity = NSUserActivity(activityType: "org.wikimedia.wikipedia.places")

        deepLink.add(to: activity)

        XCTAssertEqual(activity.wmf_placesDeepLink, deepLink)
    }
}
