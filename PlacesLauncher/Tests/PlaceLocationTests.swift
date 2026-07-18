import Foundation
import XCTest
@testable import PlacesLauncher

final class PlaceLocationTests: XCTestCase {
    func testDecodesFeedRootOptionalNameAndLongCodingKey() throws {
        let data = Data(
            """
            {
              "locations": [
                { "name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215 },
                { "lat": 40.4380638, "long": -3.7495758 }
              ]
            }
            """.utf8
        )

        let response = try JSONDecoder().decode(LocationFeedResponse.self, from: data)

        XCTAssertEqual(response.locations.count, 2)
        XCTAssertEqual(response.locations[0].name, "Amsterdam")
        XCTAssertEqual(response.locations[0].longitude, 4.8339215, accuracy: 0.0000001)
        XCTAssertNil(response.locations[1].name)
        XCTAssertEqual(response.locations[1].displayName, "Unnamed location")
    }

    func testBlankNameUsesUnnamedFallback() {
        let location = PlaceLocation(name: "  ", latitude: 1, longitude: 2)
        XCTAssertEqual(location.displayName, "Unnamed location")
    }
}

